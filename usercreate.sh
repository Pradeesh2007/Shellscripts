#!/bin/bash
echo "creating user ansible"
echo "change no to yes when passwdauthention file apper"
sudo useradd ansible
sudo passwd ansible
sudo sh -c 'echo "ansible ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers'   
sudo sh -c 'echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/60-cloudimg-settings.conf' 
echo "Restarting ssh deamon"
sudo systemctl restart ssh
sudo systemctl restart sshd
echo "user created succesfully..............."
