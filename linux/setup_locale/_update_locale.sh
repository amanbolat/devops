#!/usr/bin/env bash

set -euo pipefail

srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo tee /etc/default/locale <<EOF
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8
EOF
