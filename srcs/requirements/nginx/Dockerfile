FROM debian:bookworm

RUN apt update && \
    apt upgrade -y && \
    apt install -y nginx openssl

COPY ./conf/my_nginx.conf /
COPY ./tools/script.sh /
RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]