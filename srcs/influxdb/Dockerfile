FROM alpine:latest

#Installing essential packages
RUN	apk update && \
	apk add influxdb && \
	apk add --no-cache --upgrade bash && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Getting live !
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ./start.sh
EXPOSE 8086
