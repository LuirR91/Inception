#!/bin/bash
DOMAIN="$USER$DOMAIN_SUFFIX"

if [ -f /my_nginx.conf ]; then

    echo "Generating key and certificate (OpenSSL) ..."
    openssl req -x509 \
                -days 365 \
                -out /etc/ssl/certs/$DOMAIN.crt \
                -nodes \
                -newkey rsa \
                -keyout /etc/ssl/private/$DOMAIN.key \
                -subj "/C=PT/L=Lisbon/O=42Lisboa/OU=student/CN=$DOMAIN" > /dev/null 2>&1
    
    echo "Configuring Nginx ..."
    sed -i "s/domain_here/$DOMAIN/g" my_nginx.conf
    mv my_nginx.conf /etc/nginx/conf.d/$DOMAIN.conf
    mkdir -p /run/nginx
fi

echo "Nginx is ready!"
nginx -g "daemon off;"