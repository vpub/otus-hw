#!/bin/bash
yum -y install epel-release
yum -y install borgbackup
useradd -m borg
mkdir /home/borg/.ssh
