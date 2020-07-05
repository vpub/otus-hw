#!/bin/bash

yum install httpd -y
cp /vagrant/source/httpd@.service /etc/systemd/system/
cp /vagrant/source/httpd-first /etc/sysconfig/
cp /vagrant/source/httpd-second /etc/sysconfig/
cp /vagrant/source/first.conf /etc/httpd/conf/
cp /vagrant/source/second.conf /etc/httpd/conf/
systemctl enable httpd@first
systemctl enable httpd@second
systemctl start httpd@first
systemctl start httpd@second
