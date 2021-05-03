#!/bin/sh

### Локальные переменные  ####
DATE=`date +%d%m%Y`
BACKUP_DIR="/mnt/share/upload/dbase"
### Переменные доступа к СУБД ####
DB_USER="meno"
DB_PASSWORD="UserPass"
DB_NAME="wordpress"

### Резервное копирование баз в локальную папку  ###

mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME | gzip > $BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz

### Проверка выгрузки ###
if test $? = 0
then
 echo "Файлы выгружены на сервер"
else
 echo "Ошибка выгрузки на сервер"
fi