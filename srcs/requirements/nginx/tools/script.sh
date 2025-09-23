#!/bin/bash
set -e
DOMAIN="$USER$DOMAIN_SUFFIX"

if [ -f /ft_nginx.conf ]; then
    echo "Generating key and certificate (OpenSSL) ..."
    mkdir -p /etc/ssl/private /etc/ssl/certs
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/$DOMAIN.key \
        -out /etc/ssl/certs/$DOMAIN.crt \
        -subj "/C=PT/L=Lisbon/O=42Lisboa/OU=student/CN=$DOMAIN" > /dev/null 2>&1

    echo "Configuring Nginx ..."
    sed -i "s/domain_here/$DOMAIN/g" /ft_nginx.conf
    mv /ft_nginx.conf /etc/nginx/conf.d/$DOMAIN.conf
    mkdir -p /run/nginx
fi

echo "Nginx is ready!"
nginx -g "daemon off;"
