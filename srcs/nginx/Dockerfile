FROM alpine:latest

#Installing essential packages
RUN	apk update			&& \
	apk add openrc --no-cache	&& \
	apk add openssh			&& \
	apk add openssl			&& \
	apk add nginx			&& \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

#Creating user for the web server
RUN adduser -D -g 'www' www

#Setting up web server files and permissions
RUN mkdir -p /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
RUN mkdir -p /run/nginx

#Nginx config file and webpage
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html

#Creating SSH user and SSL key
RUN adduser -D user
RUN echo "user:password" | chpasswd
RUN ssh-keygen -A
RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Writing up the welcome message :)
RUN echo "Welcome to SSH :)" > /etc/motd

#Getting live !
COPY start.sh ./start.sh
RUN chmod +x /start.sh

CMD sh ./start.sh
EXPOSE 80
EXPOSE 443
EXPOSE 22
