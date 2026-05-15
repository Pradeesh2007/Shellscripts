#!/bin/bash
echo "creating user "
read -p 'Enter the user name' name
sudo adduser $name
sudo sh -c 'echo "$name ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers'   
sudo sh -c 'echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/60-cloudimg-settings.conf' 
echo "Restarting ssh deamon"
sudo systemctl restart ssh
sudo systemctl restart sshd
echo "user created succesfully..............."

# git clone https://github.com/Pradeesh2007/shell.git  && chmod +x shell/usercreate.sh  && ./shell/usercreate.sh
