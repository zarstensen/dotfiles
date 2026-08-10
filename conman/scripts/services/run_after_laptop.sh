#!/bin/bash
set -eufo pipefail

sudo systemctl enable --now keyd
sudo systemctl enable --now tuned
sudo systemctl enable --now tuned-ppd
