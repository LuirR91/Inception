FROM debian:bookworm

RUN apt update -y && \
	apt upgrade -y && \
	apt install -y mariadb-server

COPY ./tools/script.sh /
RUN chmod +x /script.sh

ENTRYPOINT [ "/script.sh" ]
