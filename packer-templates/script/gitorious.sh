#!/bin/bash -eux

echo '==> Installing Gitorious'

yum install -y git

cd /tmp
git clone https://gitorious.org/gitorious/ce-installer.git
cd ce-installer
git checkout -f v3.1.1
echo "" | ./install

echo '==> Customizing message of the day'
echo 'Welcome to your Gitorious virtual machine.' > /etc/motd
