#!/bin/bash
set -e

DOMAIN="$USER$DOMAIN_SUFFIX"
SITE_URL="https://$DOMAIN"
WEBROOT=/var/www/html
MARKER="$WEBROOT/.installed"

# Ensure PHP‑FPM listens on TCP for Nginx
sed -i "s#^listen = .*#listen = 0.0.0.0:9000#" /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php

if [ ! -f "$MARKER" ]; then
    mkdir -p "$WEBROOT"
    cd "$WEBROOT"
    rm -rf ./*

    echo "Installing WP-CLI ..."
    curl -sSLo /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x /usr/local/bin/wp

    echo "Waiting for MariaDB ..."
    until nc -z -w1 mariadb 3306; do sleep 1; done

    echo "Downloading and configuring WordPress ..."
    wp core download --allow-root --quiet
    wp config create --allow-root \
        --dbname="$DOMAIN" \
        --dbuser="$USER" \
        --dbpass="$DB_USER_PASSWORD" \
        --dbhost=mariadb

    wp core install --skip-email --allow-root \
        --url="$SITE_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    # Create extra author only if it doesn't exist and email isn't taken
    if ! wp user get "$USER" --allow-root >/dev/null 2>&1; then
        ADMIN_EMAIL=$(wp user get "$WP_ADMIN_USER" --field=user_email --allow-root)
        if [ "$ADMIN_EMAIL" != "$USER_EMAIL" ]; then
            wp user create --role=author --allow-root \
                --user_pass="$WP_USER_PASSWORD" \
                "$USER" \
                "$USER_EMAIL"
        else
            echo "Skipping extra user: $USER_EMAIL already used by admin."
        fi
    else
        echo "User '$USER' already exists. Skipping creation."
    fi

    touch "$MARKER"
fi

echo "Wordpress is ready!"
exec php-fpm8.2 -F