#!/bin/bash

# HOME
sudo tar cpf /archive/home-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / home

# SSH
sudo tar cpf /archive/ssh-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / etc/ssh/sshd_config

# RDP
sudo tar cpf /archive/xrdp-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / etc/xrdp/xrdp.ini

# FTP
sudo tar cpf /archive/vsftpd-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / etc/vsftpd.conf

# /var/log
sudo tar cpf /archive/varlog-backup-$(date '+%d.%B.%Y_%H:%M').tar -C / var/log

# To delete files older than 30 days
find /archive/* -mtime +30 -delete