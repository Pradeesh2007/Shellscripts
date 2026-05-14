#!/bin/bash
echo "enter the key name only 'minato' then only the script wil works"
ssh-keygen 
echo "copy the public key to the server"
ssh-copy-id -i ./minato.pub ansible@$1
ssh-copy-id -i ./minato.pub ansible@$2
ssh-copy-id -i ./minato.pub ansible@$3
echo "private_key_file = ./minato" >> ansible.cfg
echo "test the connection"
ansible all -m ping -u ansible --private-key ./minato
# git clone https://github.com/Pradeesh2007/shell.git  && chmod +x shell/keyscript.sh  && ./shell/keyscript.sh
