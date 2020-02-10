#!/bin/bash
# Script to create raid10

mdadm --create --verbose /dev/md10 --level=10 --raid-devices=6 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
mdadm --detail /dev/md10
