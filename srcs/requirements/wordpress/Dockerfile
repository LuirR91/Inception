FROM debian:bookworm

WORKDIR /var/www/html

RUN apt update && \
    apt upgrade -y && \
    apt install -y php-fpm php-mysql curl netcat-openbsd

COPY ./tools/script.sh /
RUN chmod +x /script.sh

EXPOSE 9000
ENTRYPOINT ["/script.sh"]
