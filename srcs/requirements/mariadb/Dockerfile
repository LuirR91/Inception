FROM debian:bookworm

RUN apt update && \
    apt upgrade -y && \
    apt install mariadb-server -y

COPY ./tools/script.sh /
RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]
