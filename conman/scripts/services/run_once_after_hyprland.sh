#!/bin/bash
set -eufo pipefail

systemctl --user enable --now hyprpolkitagent
