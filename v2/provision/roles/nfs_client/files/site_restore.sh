#!/bin/sh

RESTORE_DATE="" #ddmmyyyy
BACKUP_DIR="/mnt/share/upload/site"
SITE_DIR="/usr/share/nginx/html/wordpress"

### Восстановление файлов в локальную папку  ###

tar -C $SITE_DIR -xvf $BACKUP_DIR/wordpress_$RESTORE_DATE.tar.gz

### Проверка выгрузки ###
if test $? = 0
then
 echo "Файлы восстановлены"
else
 echo "Ошибка восстановления файлов"
fi