from __future__ import annotations
from pydantic import BeforeValidator
from types import NoneType
from typing import Any
from typing import Annotated
from enum import Enum
from pathlib import Path
from itertools import chain
from conman.src.assets import SPECS_DIR
import yaml
from pydantic import BaseModel

class ScriptTiming(Enum):
    Before = "before"
    After = "after"

class ScriptFreq(Enum):
    Once = "once"
    Onchange = "onchange"

def group_entry_validator(val: Any) :
    if not isinstance(val, dict) or len(val) != 1:
        return val
    
    ((group_name, group),) = val.items()

    if not isinstance(group_name, str) or not isinstance(group, list):
        return val
    
    return (group_name, tuple(group))

def script_entry_validator(val: Any) :
    if not isinstance(val, dict) or len(val) != 1:
        return val
    
    ((script_path, script_props),) = val.items()

    if not isinstance(script_path, str) or not isinstance(script_props, (NoneType, str)):
        return val

    script_props = script_props or ""
    script_props = script_props.strip().split()
    
    match script_props:
        case []:
            return (script_path, None, None)
        case [freq]:
            return (script_path, ScriptFreq(freq), None)
        case [freq, timing]:
            return (script_path, ScriptFreq(freq), ScriptTiming(timing))
        case _:
            raise ValueError("Too many script properties supplied!")

type NameEntry = str
type GroupEntry = Annotated[tuple[str, tuple[PkgEntry, ...]], BeforeValidator(group_entry_validator)]
type ScriptEntry = Annotated[tuple[str, ScriptFreq | None, ScriptTiming | None], BeforeValidator(script_entry_validator)]
type PkgEntry = NameEntry | ScriptEntry | GroupEntry

def script_entry_to_path(entry: ScriptEntry) -> Path:
    (script_path_str, freq, timing) = entry
    script_path = Path(script_path_str)

    script_folder = script_path.parent
    script_file = script_path.name

    freq_part = ""

    if freq is not None:
        freq_part = freq.value + "_"

    timing_part = ""

    if timing is not None:
        timing_part = timing.value + "_"

    return script_folder / f"run_{freq_part}{timing_part}{script_file}"


class Spec(BaseModel):
    pkg_spec: tuple[PkgEntry, ...]

    @staticmethod
    def load(category: str) -> Spec:
        with open(SPECS_DIR / f"{category}.yaml", "r") as f:
            return Spec(pkg_spec=yaml.safe_load(f))

    def extract_pkgs(self) -> tuple[str, ...]:
        def flatten_spec(spec: PkgEntry) -> tuple[str, ...]:
            match spec:
                case str():
                    return (spec,)
                case (str(), ScriptFreq() | None, ScriptTiming() | None):
                    return tuple()
                case (str() as pkg, tuple() as specs):
                    return (pkg, *chain.from_iterable(map(flatten_spec, specs)))

        return tuple(
            filter(
                lambda p: not p.startswith("."),
                chain.from_iterable(map(flatten_spec, self.pkg_spec)),
            )
        )

    def extract_scripts(self) -> tuple[ScriptEntry, ...]:
        def flatten_spec(spec: PkgEntry) -> tuple[ScriptEntry, ...]:
            match spec:
                case str():
                    return tuple()
                case (str(), ScriptFreq() | None, ScriptTiming() | None):
                    return (spec,)
                case (str() as pkg, tuple() as specs):
                    return tuple(chain.from_iterable(map(flatten_spec, specs)))

        return tuple(
            chain.from_iterable(map(flatten_spec, self.pkg_spec))
        )


Spec.model_rebuild()
