#!/bin/bash

sudo adduser ansible
sudo passwd ansible
sudo sh -c 'echo "ansible ALL=(ALL:ALL) ALL" >> /etc/sudoers'   

echo "user created succesfully..................."
