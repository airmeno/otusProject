#!/bin/bash

####################################################
## ZABBIX INSTALL SCRIPT
##
## Zabbix 5 - CentOS - MySQL - Apache
####################################################

sudo yum install -y mariadb-server
sudo systemctl enable --now mysqld.service

sudo  rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
sudo  yum clean all

sudo yum install -y zabbix-server-mysql zabbix-agent
sudo yum install -y centos-release-scl

sudo sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/zabbix.repo

sudo yum install -y zabbix-web-mysql-scl zabbix-apache-conf-scl


sudo mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -uroot -e "create user zabbix@localhost identified by 'zabbix';" 
sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost;"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
sudo mysql -uroot -e "quit;"


sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

sudo sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf
sudo echo "php_value[date.timezone] = Europe/Moscow" >> /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf


sudo systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm mariadb
sudo systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
