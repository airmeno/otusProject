### LVM

lvdisplay
vgdisplay

pvs - 

lvs

dd if=/dev/zero of=/mnt/share/data/test.log bs=1M count=800 status=progress


parted -s /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sdb1 
mount -t etx4 /dev/sdb1 /var/lib/mysql

### MariaDB

mysql -u meno -p -e "CREATE DATABASE wordpress"; 

mysql -u meno -p -e "show databases"; 

CREATE DATABASE www;

mysql_secure_installation


CREATE USER 'meno'@'%' IDENTIFIED BY 'Pa$$w0rd';
GRANT ALL PRIVILEGES ON *.* TO 'meno'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;



SELINUX

MySQL (MariaDB) из командной строки подключается к серверу, но Wordpress (скрипты PHP) нет.

Причина в политиках безопасности SELinux.

По умолчанию политика httpd_can_network_connect_db отключена (веб-сервер не может связаться с удаленной БД.)
```
getsebool -a | grep httpd_can_network_connect_db 

setsebool -P httpd_can_network_connect_db 1 
```


### iSCSI

https://www.server-world.info/en/note?os=CentOS_7&p=iscsi&f=4

https://linux-admins.ru/article.php?id_article=66&article_title=Установка%20и%20настройка%20Iscsi%20на%20CentOS7


If SELinux is enabled, change SELinux Context.
```
chcon -R -t tgtd_var_lib_t /var/lib/iscsi_disks
semanage fcontext -a -t tgtd_var_lib_t /var/lib/iscsi_disks
```

### Zabbix 

To solve the problem zabbix server is not running you have to :

First - Check that all of the database parameters in zabbix.conf.php ( /etc/zabbix/web/zabbix.conf.php) and zabbix_server.conf ( /etc/zabbix/zabbix_server.conf) to be the same. Including:
• DBHost
• DBName
• DBUser
• DBPassword

Second- Change SElinux parameters:
```
#setsebool -P httpd_can_network_connect on
#setsebool -P httpd_can_connect_zabbix 1
#setsebool -P zabbix_can_network 1
```

Zabbix: cannot start preprocessing service: Cannot bind socket to “/var/run/zabbix/zabbix_server_preprocessing.sock”: [98] Address already in use.
Zabbix error:

 10272:20190212:003104.073 cannot start preprocessing service: Cannot bind socket to "/var/run/zabbix/zabbix_server_preprocessing.sock": [98] Address already in use.
 10239:20190212:003104.078 One child process died (PID:10272,exitcode/signal:1). Exiting …

related to:
```
# cat /var/log/audit/audit.log|grep -Ei denied|tail
type=AVC msg=audit(1549949530.062:12551): avc:  denied  { unlink } for  pid=10521 comm="zabbix_server" name="zabbix_server_preprocessing.sock" dev="tmpfs" ino=3998803 scontext=system_u:system_r:zabbix_t:s0 tcontext=system_u:object_r:zabbix_var_run_t:s0 tclass=sock_file

is solved by:

# grep AVC /var/log/audit/audit.log | audit2allow -M systemd-allow && semodule -i systemd-allow.pp

```