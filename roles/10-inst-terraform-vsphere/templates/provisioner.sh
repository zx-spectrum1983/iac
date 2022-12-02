#!/bin/bash

HOSTNAME="$1"
OLDHOSTNAME="$2"
USERNAME="$3"
PASSWORD="$4"

hostnamectl set-hostname "$HOSTNAME"
sed -i "s/$OLDHOSTNAME/$HOSTNAME/g" /etc/hosts
pkill dhclient && /sbin/dhclient -4

id -u $USERNAME &>/dev/null || (useradd -s /bin/bash -m $USERNAME && echo "$USERNAME:$PASSWORD"|chpasswd && usermod -aG sudo $USERNAME)

mkdir /home/$USERNAME/.ssh && touch /home/$USERNAME/.ssh/authorized_keys
chmod 700 /home/$USERNAME/.ssh && chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
cat /tmp/id_rsa.pub >> /home/$USERNAME/.ssh/authorized_keys

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
chmod 440 /etc/sudoers.d/$USERNAME
