
# User Creation Script

Run the command below to clone and execute the script:

```bash
git clone https://github.com/Pradeesh2007/Shellscripts.git && \
chmod +x shell/usercreate.sh && \
./shell/usercreate.sh
````

## What this script does

* Creates a new user
* Grants passwordless sudo access (`NOPASSWD:ALL`)
* Enables SSH password authentication
* Restarts the SSH service

> Use only on trusted systems, as the created user gets full root access.

---
