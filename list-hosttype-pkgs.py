#!/usr/bin/env python3
import json
import subprocess
import sys

HOSTTYPE_CATEGORIES = {
    "desktop": [
        "pkgs_common",
        "pkgs_fonts",
        "pkgs_music",
        "pkgs_dev",
        "pkgs_gaming",
    ],
    "laptop": [
        "pkgs_common",
        "pkgs_laptop",
        "pkgs_fonts",
        "pkgs_music",
        "pkgs_dev",
    ],
}


def main():
    assert len(sys.argv) == 2, f"Missing hosttype arg, must be one of {HOSTTYPE_CATEGORIES.keys()}"
    role = sys.argv[1]
    categories = HOSTTYPE_CATEGORIES[role]

    # get the packages from chezmoi, so we let chezmoi parse them as yaml for us essentially.
    data = json.loads(subprocess.check_output(["chezmoi", "data", "--format=json"]))

    for cat in categories:
        for pkg in data.get(cat, []):
            print(pkg)


if __name__ == "__main__":
    main()
