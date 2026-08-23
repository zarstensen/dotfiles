from __future__ import annotations

import os
from enum import Enum
from pathlib import Path

import yaml
from pydantic import BaseModel

# TODO: no point in this being static like this?
class HostType(Enum):
    DESKTOP = "desktop"
    LAPTOP = "laptop"
    HEADLESS = "headless"
    UNKNOWN = None


class HostConfig(BaseModel):
    pkgs: tuple[str, ...] = tuple()
    scripts: tuple[str, ...] = tuple()


def get_host_type() -> HostType:
    hosttype = os.environ["_CHEZMOI_HOSTTYPE"]

    for ht in HostType:
        if ht.value == hosttype:
            return ht

    return HostType.UNKNOWN


def get_host_config(config_dir: Path, host_type: HostType) -> HostConfig:
    if host_type == HostType.UNKNOWN:
        raise ValueError(f"Unknown Host '{host_type}'")

    with open(config_dir / f"{host_type.value}.yaml", "r") as f:
        return HostConfig.model_validate(yaml.safe_load(f))
