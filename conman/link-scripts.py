import contextlib
from pathlib import Path
import shutil
from conman.src.assets import SCRIPTS_DIR
from conman.src.assets import HOSTTYPES_DIR
from conman.src import hostconfig
import os
import bracex

# get hosttype
host_type = hostconfig.get_host_type()

# read hosttype config thingy
host_cfg = hostconfig.get_host_config(HOSTTYPES_DIR, host_type)


# find all script paths which matches script globs in config
scripts = [
    script
    for script_glob_braced in host_cfg.scripts
    for script_glob in bracex.expand(script_glob_braced)
    for script in SCRIPTS_DIR.glob(script_glob)
]

chezmoi_script_dir = Path(os.environ["CHEZMOI_SOURCE_DIR"]) / ".chezmoiscripts"

# remove the current scripts dir
with contextlib.suppress(FileNotFoundError):
    shutil.rmtree(chezmoi_script_dir)

os.mkdir(chezmoi_script_dir)

# copy the scripts to the scripts dir
for script in scripts:
    dest = chezmoi_script_dir / script.relative_to(SCRIPTS_DIR)
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy(script, dest)
