#!/bin/bash
echo "enter the key name only 'minato'"
ssh-keygen 
echo "copy the public key to the server"
ssh-copy-id -i ./minato ansible@$1
ssh-copy-id -i ./minato ansible@$2
ssh-copy-id -i ./minato ansible@$3
echo "test the connection"
ansible all -m ping -u ansible
