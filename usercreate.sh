#!/usr/bin/env bash
set -euo pipefail
echo "Creating a new user..."
read -rp "Enter the username: " username
if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "Invalid username."
    exit 1
fi
if id "$username" &>/dev/null; then
    echo "User '$username' already exists."
    exit 1
fi
sudo adduser "$username"
sudo usermod -aG sudo "$username"
sudo bash -c "cat > /etc/sudoers.d/$username" <<EOF
$username ALL=(ALL:ALL) NOPASSWD:ALL
EOF
sudo chmod 440 "/etc/sudoers.d/$username"
sudo visudo -cf "/etc/sudoers.d/$username"
SSH_CONF="/etc/ssh/sshd_config.d/60-cloudimg-settings.conf"
sudo mkdir -p /etc/ssh/sshd_config.d
echo "PasswordAuthentication yes" | sudo tee "$SSH_CONF" >/dev/null
if systemctl list-units --type=service | grep -q ssh.service; then
    sudo systemctl restart ssh
elif systemctl list-units --type=service | grep -q sshd.service; then
    sudo systemctl restart sshd
fi
echo "User '$username' created successfully."

# git clone https://github.com/Pradeesh2007/shell.git  && chmod +x shell/usercreate.sh  && ./shell/usercreate.sh
