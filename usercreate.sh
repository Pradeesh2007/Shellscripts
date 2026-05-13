#!/bin/bash
echo "creating user ansible"

sudo useradd ansible
sudo passwd ansible
sudo sh -c 'echo "ansible ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers'   
sudo sh -c 'echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/60-cloudimg-settings.conf' 
echo "Restarting ssh deamon"
sudo systemctl restart ssh
sudo systemctl restart sshd
echo "user created succesfully..............."

# git clone https://github.com/Pradeesh2007/shell.git  && chmod +x shell/usercreate.sh  && ./shell/usercreate.sh