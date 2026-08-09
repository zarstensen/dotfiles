from __future__ import annotations
from itertools import chain
from conman.src.assets import PKGS_DIR
import yaml
from pydantic import BaseModel


type PkgEntry = str | tuple[str, tuple[PkgEntry, ...]]


class Packages(BaseModel):
    pkg_spec: tuple[PkgEntry, ...]

    @staticmethod
    def load(category: str) -> Packages:
        with open(PKGS_DIR / f"{category}.yaml", "r") as f:
            return _IrPackages(pkg_spec=yaml.safe_load(f)).to_packages()

    def get_pkgs(self) -> tuple[str, ...]:
        def flatten_spec(spec: PkgEntry) -> tuple[str, ...]:
            match spec:
                case str():
                    return (spec,)
                case (str() as pkg, tuple() as specs):
                    return (pkg, *chain.from_iterable(map(flatten_spec, specs)))

        return tuple(
            filter(
                lambda p: not p.startswith("."),
                chain.from_iterable(map(flatten_spec, self.pkg_spec)),
            )
        )


Packages.model_rebuild()

type _IrPkgEntry = str | dict[str, tuple[_IrPkgEntry, ...]]


class _IrPackages(BaseModel):
    pkg_spec: tuple[_IrPkgEntry, ...]

    def to_packages(self) -> Packages:
        def _cpkgs(entry: _IrPkgEntry) -> PkgEntry:
            match entry:
                case str():
                    return entry
                case dict():
                    assert len(entry) == 1
                    pkg, pkgs = next(iter(entry.items()))
                    return (pkg, tuple(map(_cpkgs, pkgs)))

        return Packages(pkg_spec=tuple(map(_cpkgs, self.pkg_spec)))


_IrPackages.model_rebuild()
