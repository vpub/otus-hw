#!/bin/bash
 
mkdir /opt/jira
cd /opt/jira
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-8.8.0-x64.bin
chmod +x atlassian-jira-software-8.8.0-x64.bin
yes "" | ./atlassian-jira-software-8.8.0-x64.bin
cp /vagrant/source/jira.service /etc/systemd/system/
chmod 664 /etc/systemd/system/jira.service
systemctl daemon-reload
systemctl enable jira.service
systemctl stop jira.service
systemctl start jira.service
