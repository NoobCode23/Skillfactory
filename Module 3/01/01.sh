#!/bin/bash

## 01 ##

if grep -R "jammy-backports" /etc/apt/sources.list
then
    echo -n "OK"
    sleep 1
else
    echo "deb http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse" | sudo sh -c 'cat >> /etc/apt/sources.list'
    sleep 1
    echo "Added!" && tail -n 1 /etc/apt/sources.list
fi

## 02 ##

sudo apt update

## 03 ##

if ! apache2 -v 2>/dev/null 
then
    sudo apt install apache2 apache2-doc apache2-utils -y
    sleep 2
    apache2 -v
else
    echo "Already installed."
fi

sleep 2
if systemctl is-active -q apache2
then
    echo "Apache running - OK"
else
    echo "Apache stopped - FAIL"
fi

## 04 ##

sudo apt install software-properties-common -y && echo "${green}${icon_ok} Done! ${nocolor}\n"
sleep 2
echo "${cyan}${icon_wait} Installing repo for Python 3.10 ${nocolor}"
sudo add-apt-repository ppa:deadsnakes/ppa -y && echo "${green}${icon_ok} Done! ${nocolor}\n"
sleep 2
echo "${green}${icon_ok} Python Installed Successfully! ${nocolor}"
sleep 2
python3 --version 

## 05 ##

if ! ssh -V 2>/dev/null
then
    sudo apt install openssh-server -y
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
    sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
    sudo sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no\n#PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo systemctl start ssh
else
    ssh -V
fi

if systemctl is-active -q ssh
then
    sleep 2
    echo "SSH OK"
else
    echo "SSH FAIL"
    sleep 2
    sudo systemctl start ssh && echo "I run it :)"
fi

## 06 Open ports##

sudo ufw allow from any to any port 80,443 proto tcp comment 'Web ports'
sleep 1
sudo ufw allow 22/tcp comment 'SSH'

## 07 Count my books##

find /home/books/ -type f | wc -l

## 08 Backup my books##

BOOKS = "/home/books/*.fb2"
DATE=$(date +"%d-%b-%Y")
tar -zcvf books-$DATE.tgz $BOOKS
mv *.tgz /home/backups

## 09 Clean old files (30 days)##

find ./my_dir -mtime +30 -type f -delete

## 10 System maintenance##

echo "Starting maintenance"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get autoclean
echo "Maintenance completed"
