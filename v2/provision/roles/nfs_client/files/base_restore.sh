#!/bin/sh

RESTORE_DATE="" #ddmmyyyy
BACKUP_DIR="/mnt/share/upload/dbase"
### Переменные доступа к СУБД ####
DB_USER="meno"
DB_PASSWORD="UserPass"
DB_NAME="wordpress"

### Резервное копирование баз в локальную папку  ###

zcat $BACKUP_DIR/$DB_NAME_$RESTORE_DATE.sql.gz | mysql -u$DB_USER -p$DB_PASSWORD $DB_NAME

### Проверка выгрузки ###
if test $? = 0
then
 echo "База восстановлена"
else
 echo "Ошибка восстановления базы"
fi