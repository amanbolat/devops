#!/usr/bin/env bash

set -euo pipefail

srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to validate username
validate_username() {
    if [[ "$1" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]; then
        return 0
    else
        echo "Invalid username"
        exit 1
    fi
}

# Function to validate SSH public key
validate_ssh_pub_key() {
    if [[ "$1" =~ ssh-(rsa|dss|ed25519) ]]; then
        return 0
    else
        echo "Invalid SSH public key"
        exit 1
    fi
}

# Ask if the script should run on remote machine
read -rp "Should this script run on a remote machine? (yes/no): " run_remote

if [ "$run_remote" != "yes" ]; then
  if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only be run on Linux locally."
    exit 1
  fi
fi

# Ask the username for a new user
read -rp "Enter the username for the new user: " username
validate_username "$username"

# Ask to input ssh pub key for a new user
read -rp "Enter the ssh public key for the new user: " ssh_pub_key
validate_ssh_pub_key "$ssh_pub_key"

# Ask the password for a new user. Input should not be shown in the terminal
read -srp "Enter the password for the new user: " password
echo

if [ "$run_remote" = "yes" ]; then
    # Ask for the user name and hostname for the remote machine
    read -rp "Enter the username for the remote machine: " remote_username
    read -rp "Enter the hostname for the remote machine: " remote_hostname

    # Create a new user and related commands on the remote machine
    ssh "$remote_username@$remote_hostname" 'bash -s' < "$srcdir"/_create_user.sh "$username" "$password" "$ssh_pub_key"
else
    bash -s "$srcdir"/_create_user.sh "$username" "$password" "$ssh_pub_key"
fi
