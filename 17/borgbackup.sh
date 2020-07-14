#!/bin/bash

LOCKFILE=/tmp/lockfile
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "already running"
    exit
fi

# Make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# Configure backup
BACKUP_HOST='192.168.168.102'
BACKUP_USER='borg'
BACKUP_REPO=Repo

# Путь к файлу логгирования. Ниже перенаправление в файл лога из stderr
LOG=/var/log/borg_backup.log


# Make backup
export BORG_PASSPHRASE='borgpass'

borg create \
  --stats --list --debug --progress \
  ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO}::"etc-server-{now:%Y-%m-%d_%H:%M:%S}" \
  /etc 2>> ${LOG}


# Политика хранения. Команда borg prune оставляет в архиве только то, что явно указано. В нашем случае необходимо хранить бэкапы за последние 30 дней и по одному за предыдущие два месяца:
borg prune \
  -v --list \
  ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO} \
  --keep-daily=30 \
  --keep-monthly=2 2>> ${LOG}

# Delete lockfile
rm -f ${LOCKFILE}
