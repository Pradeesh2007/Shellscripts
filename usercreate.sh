#!/bin/bash
echo "creating user ansible"
echo "change no to yes when passwdauthention file apper"
sudo adduser ansible
sudo passwd ansible
sudo sh -c 'echo "ansible ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers'   
sudo nano /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
echo "Restarting ssh deamon"
sudo systemctl restart ssh
sudo systemctl restart sshd
echo "user created succesfully..............."
