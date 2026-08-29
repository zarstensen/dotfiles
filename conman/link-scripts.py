from conman.src.spec import script_entry_to_path
from itertools import chain
from conman.src.spec import Spec
import contextlib
from pathlib import Path
import shutil
from conman.src.assets import SCRIPTS_DIR
from conman.src.assets import HOSTTYPES_DIR
from conman.src import hostconfig
import os

chezmoi_script_dir = Path(os.environ["CHEZMOI_SOURCE_DIR"]) / ".chezmoiscripts"

# get hosttype
host_type = hostconfig.get_host_type()

# read hosttype config thingy
host_cfg = hostconfig.get_host_config(HOSTTYPES_DIR, host_type)


scripts = (
    *chain.from_iterable(map(lambda cat: Spec.load(cat).extract_scripts(), host_cfg.pkgs)),
)

# remove the current scripts dir
with contextlib.suppress(FileNotFoundError):
    shutil.rmtree(chezmoi_script_dir)

os.mkdir(chezmoi_script_dir)

# copy the scripts to the scripts dir
for script in scripts:
    script_src_path, _, __ = script

    dest = chezmoi_script_dir / script_entry_to_path(script)
    dest.parent.mkdir(parents=True, exist_ok=True)

    shutil.copy(Path(SCRIPTS_DIR) / script_src_path, dest)
