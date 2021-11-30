#!/bin/bash

nohup ./init_mysql.sh > /dev/null 2>&1 &

sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

#Launching Telegraf && Mysql services
telegraf &
/usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql"
/usr/bin/mysqld_safe --user=root --datadir="/var/lib/mysql"
#/usr/bin/mysqld --user=root --datadir="/var/lib/mysql"
