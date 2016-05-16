#!/bin/sh

# Cron example config:
# 30 20 * * * /backup/backup.sh

NOW=$(date +"%Y%m%d_%H%M")
BACKUP_PATH="/backup/${NOW}"

if [ ! -d ${BACKUP_PATH} ];
then
    echo "Creating ${BACKUP_PATH}"
    mkdir ${BACKUP_PATH}
fi

echo "Generating backup...";
tar -cvzf ${BACKUP_PATH}/backup.tar --directory /var/lib jenkins

echo "Backup done!"
