
# User Creation Script

Run the command below to clone and execute the script:

```bash
git clone https://github.com/Pradeesh2007/Shellscripts.git && \
chmod +x Shellscripts/usercreate.sh && \
./Shellscripts/usercreate.sh
````

## What this script does

* Creates a new user
* Grants passwordless sudo access (`NOPASSWD:ALL`)
* Enables SSH password authentication
* Restarts the SSH service

> Use only on trusted systems, as the created user gets full root access.

---
---
---


# SSH Key Setup Script

Generate an SSH key and copy it to multiple servers.

## Usage

```bash
git clone https://github.com/Pradeesh2007/Shellscripts.git && \
chmod +x Shellscripts/keyscript.sh && \
./Shellscripts/keycopyscript.sh <host1> <host2> ...
```

## Example

```bash
./Shellscripts/keycopyscript.sh user@server1 user@server2
```

## Requirements

- git
- ssh
- ssh-copy-id

