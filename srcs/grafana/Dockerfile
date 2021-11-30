FROM alpine:latest

#Installing essential packages
RUN	apk update && \
	apk add --no-cache --upgrade bash && \
	apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

RUN	wget https://dl.grafana.com/oss/release/grafana-6.7.2.linux-amd64.tar.gz && \
	tar -zxvf grafana-6.7.2.linux-amd64.tar.gz

#Copying data: users, dashboards, data sources...
COPY ./grafana.db ./grafana-6.7.2/data/
COPY start.sh /start.sh

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Getting live !
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ./start.sh
EXPOSE 3000
