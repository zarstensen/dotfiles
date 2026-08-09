from __future__ import annotations

import os
from enum import Enum
from pathlib import Path

import yaml
from pydantic import BaseModel


class HostType(Enum):
    DESKTOP = "desktop"
    LAPTOP = "laptop"
    SERVER = "server"
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
        return HostConfig()

    with open(config_dir / f"{host_type.value}.yaml", "r") as f:
        return HostConfig.model_validate(yaml.safe_load(f))
