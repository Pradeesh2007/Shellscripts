#!/bin/bash

sudo adduser ansible
sudo passwd ansible
sudo sh -c 'echo "ansible ALL=(ALL:ALL) ALL" >> /etc/sudoers'   
sudo nano /etc/ssh/sshd_config.d/60-cloudimg-settings.conf

echo "user created succesfully..................."
