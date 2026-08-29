from __future__ import annotations

import os
from pathlib import Path

import yaml
from pydantic import BaseModel

type HostType = str | None

class HostConfig(BaseModel):
    pkgs: tuple[str, ...] = tuple()
    scripts: tuple[str, ...] = tuple()


def get_host_type() -> HostType:
    return os.environ["_CHEZMOI_HOSTTYPE"]

def get_host_config(config_dir: Path, host_type: HostType) -> HostConfig:
    if host_type == None:
        raise ValueError(f"Unknown Host")

    with open(config_dir / f"{host_type}.yaml", "r") as f:
        return HostConfig.model_validate(yaml.safe_load(f))
