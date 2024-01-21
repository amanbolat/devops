#!/usr/bin/env bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

username=$1
password=$2
ssh_pub_key=$3

if id -u "$username" >/dev/null 2>&1; then
    echo "User exists, updating password"
    echo "$username:$password" | sudo chpasswd
else
    echo "Creating new user"
    sudo useradd -m -p "$(openssl passwd -1 "$password")" "$username"
    sudo usermod -aG sudo "$username"
    echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$username
    sudo mkdir -p "/home/$username/.ssh"
    echo "$ssh_pub_key" | sudo tee "/home/$username/.ssh/authorized_keys"
    sudo chown -R "$username:$username" "/home/$username/.ssh"
    sudo chmod 700 "/home/$username/.ssh"
    sudo chmod 600 "/home/$username/.ssh/authorized_keys"
fi
