FROM debian:bookworm

RUN apt update -y && \
	apt upgrade -y && \
	apt install -y nginx openssl

COPY ./config/ft_nginx.conf /
COPY ./tools/script.sh /
RUN chmod +x /script.sh

ENTRYPOINT [ "/script.sh" ]
