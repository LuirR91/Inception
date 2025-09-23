#!/bin/bash
set -e

DOMAIN="https://$USER$DOMAIN_SUFFIX"
WEBROOT=/var/www/html

if [ ! -d /run/php ]; then
    mkdir -p "$WEBROOT"
    cd "$WEBROOT"
    rm -rf ./*

    echo "Installing Wordpress Command Line Interface (WP-CLI) ..."
    curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    echo "Waiting for MariaDB ..."
    while ! nc -z -w1 mariadb 3306 ; do
        sleep 2
    done

    echo "Downloading and Configuring Wordpress ..."
    wp core download --allow-root --quiet
    wp config create --allow-root \
        --dbname="$DOMAIN" \
        --dbuser="$USER" \
        --dbpass="$DB_USER_PASSWORD" \
        --dbhost=mariadb

    echo "Installing Wordpress ..."
    wp core install --skip-email --allow-root \
        --url="$DOMAIN" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create --role=author --allow-root \
        --user_pass="$WP_USER_PASSWORD" \
        "$USER" \
        "$USER_EMAIL"

    # PHP 8.2 FPM listens on TCP 9000
    sed -i "s#^listen = .*#listen = 9000#" /etc/php/8.2/fpm/pool.d/www.conf
    mkdir -p /run/php
fi

echo "Wordpress is ready!"
php-fpm8.2 -F
