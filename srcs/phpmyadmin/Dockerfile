FROM alpine:latest
ARG IP

#Installing essential packages
RUN	apk update	&& \
	apk upgrade	&& \
	apk add bash	&& \
	apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

#Downloading PHPMyAdmin
RUN	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
	tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
	mv phpMyAdmin-4.9.0.1-all-languages /www && \
	rm -rf /var/cache/apk/*

#Saving external IP
RUN echo $IP > ip.txt

#Copying PHPMyAdmin config file
COPY phpmyadmin.inc.php /www/config.inc.php

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Getting live !
COPY start.sh .
RUN chmod +x start.sh

CMD ./start.sh
EXPOSE 5000
