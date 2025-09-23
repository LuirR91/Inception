#!/bin/bash
DOMAIN="$USER$DOMAIN_SUFFIX"

if [ ! -d /run/php ]; then
    rm -rf *
    echo "Installing Wordpress Command Line Interface (WP-CLI) ..."
    curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    while ! nc -z mariadb 3306; do
        sleep 2
    done

    echo "Downloading and Configuring Wordpress ..."
    wp core download --allow-root --quiet
    wp config create --allow-root \
    --dbname=$DOMAIN \
    --dbuser=$USER \
    --dbpass=$DB_ROOT_PASSWORD \
    --dbhost=mariabd > /dev/null 2>&1

    echo "Installing Wordpress ..."
    wp core install --skip-email --allow-root \
    --url="$DOMAIN" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="WP_ADMIN_EMAIL" > /dev/null 2>&1

    wp user create --role=author --allow-root \
    --user_pass=$WP_USER_PASSWORD $USER $USER_EMAIL > /dev/null 2>&1

    sed -i "s#listen = /run/php/php7.4-fpm.sock#listen = 9000#" /etc/php/8.2/fpm/pool.d/www.conf
    mkdir /run/php
fi

echo "Wordpress is ready!"
php-fpm8.2 -FR