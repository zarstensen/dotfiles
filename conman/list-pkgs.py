from itertools import chain
from conman.src.packages import Packages
from conman.src.assets import HOSTTYPES_DIR
from conman.src import hostconfig

host_type = hostconfig.get_host_type()
host_cfg = hostconfig.get_host_config(HOSTTYPES_DIR, host_type)

pkgs = (
    *chain.from_iterable(map(lambda cat: Packages.load(cat).get_pkgs(), host_cfg.pkgs)),
)

for pkg in sorted(pkgs):
    print(pkg)
