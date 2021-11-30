FROM alpine:latest
ARG IP

#Installing essential packages
RUN	apk update	&& \
	apk add wget	&& \
	mkdir /www	&& \
	apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

#Downloading Wordpress
RUN	wget https://wordpress.org/latest.tar.gz && \
	tar -xvf latest.tar.gz	&& \
	mv wordpress/* /www	&& \
	rm -rf /var/cache/apk/*

#Copying wordpress config file
COPY wp-config.php /www/wp-config.php

#Saving extrenal IP
RUN echo $IP > ip.txt

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Getting live !
COPY start.sh .
RUN chmod +x start.sh

CMD ./start.sh
EXPOSE 5050
