#!/bin/bash
set -eufo pipefail

cd "$CHEZMOI_WORKING_TREE"
python -m $1
