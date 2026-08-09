#!/bin/bash
set -eufo pipefail

sudo systemctl enable --now earlyoom
sudo systemctl enable --now tuned
sudo systemctl enable --now tuned-ppd
