#!/bin/bash
yum -y install epel-release
yum -y install borgbackup
cp -R /vagrant/borgbackup.sh /etc/borgbackup.sh
cp -R /vagrant/borgbackup.service /etc/systemd/system/borgbackup.service
cp -R /vagrant/borgbackup.timer /etc/systemd/system/borgbackup.timer
systemctl daemon-reload
systemctl enable borgbackup.timer
mkdir /etc/testtest
touch /etc/testtest/testtest{001..015}
