#!/bin/bash
DOMAIN="$USER$DOMAIN_SUFFIX"

echo "Configuring MariaDB ..."
service mariadb start > /dev/null
mysql -e "CREATE DATABASE IF NOT EXISTS \`$DOMAIN\` ;"
mysql -e "CREATE USER IF NOT EXISTS '$USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD' ;"
mysql -e "GRANT ALL PRIVILEGES ON \`$DOMAIN\`.* TO '$USER'@'%' ;"
mysql -e "FLUSH PRIVILEGES ;"
sleep 3
service mariadb stop > /dev/null
echo "MariaDB is ready!"
exec mysqld_safe --bind-address=0.0.0.0 > /dev/null
