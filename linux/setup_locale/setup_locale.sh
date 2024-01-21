#!/usr/bin/env bash

srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -euo pipefail

# Ask if the script should run on remote machine
read -rp "Should this script run on a remote machine? (yes/no): " run_remote

if [ "$run_remote" != "yes" ]; then
  if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only be run on Linux locally."
    exit 1
  fi
fi

if [ "$run_remote" = "yes" ]; then
    # Ask for the user name and hostname for the remote machine
    read -rp "Enter the username for the remote machine: " remote_username
    read -rp "Enter the hostname for the remote machine: " remote_hostname

    ssh "$remote_username@$remote_hostname" 'bash -s' < "$srcdir"/_update_locale.sh
else
    bash -s "$srcdir"/_update_locale.sh
fi
