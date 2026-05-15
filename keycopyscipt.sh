#!/usr/bin/env bash
set -euo pipefail
echo "Generating SSH key if it does not already exist..."
KEY_PATH="${HOME}/.ssh/id_ed25519"
if [[ ! -f "${KEY_PATH}" ]]; then
    ssh-keygen -t ed25519 -f "${KEY_PATH}" -N ""
    echo "SSH key created at ${KEY_PATH}"
else
    echo "SSH key already exists at ${KEY_PATH}"
fi
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 user@host1 [user@host2 ...]"
    exit 1
fi
echo ""
echo "Copying public key to servers..."
for host in "$@"; do
    echo "----------------------------------------"
    echo "Copying key to: ${host}"
    ssh-copy-id -i "${KEY_PATH}.pub" "${host}"
    echo "Done for ${host}"
done
echo ""
echo "All keys copied successfully."
# git clone https://github.com/Pradeesh2007/shell.git  && chmod +x shell/keyscript.sh  && ./shell/keyscript.sh
