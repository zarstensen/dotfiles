#!/bin/bash
set -eufo pipefail

chsh -s "$(readlink -f $(command -v fish))"
