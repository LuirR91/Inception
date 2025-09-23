FROM debian:bookworm

RUN apt update -y && \
	apt upgrade -y && \
	apt install -y php php-fpm php-mysql curl netcat-openbsd

COPY ./tools/script.sh /
RUN chmod +x /script.sh

EXPOSE 9000

ENTRYPOINT [ "/script.sh" ]