#!/bin/bash

yum install -y mc wget vim
cp /vagrant/source/watchlog /etc/sysconfig/
cp /vagrant/source/watchlog.log /var/log/
cp /vagrant/script/watchlog.sh /opt/
chmod +x /opt/watchlog.sh
cp /vagrant/source/watchlog.service /etc/systemd/system/
cp /vagrant/source/watchlog.timer /etc/systemd/system/
systemctl daemon-reload
systemctl enable watchlog.service
systemctl enable watchlog.timer
systemctl start watchlog.service
systemctl start watchlog.timer
