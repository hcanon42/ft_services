FROM alpine:latest

#Installating essential packages
RUN	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache && \
	apk update && \
	apk add mariadb mariadb-client && apk add --no-cache --upgrade bash && \
	rm -rf /var/cache/apk/*

RUN mysql --version

#Copying initialisation script
COPY ./init_docker.sh .
COPY ./init_mysql.sh .
COPY start.sh /start.sh
COPY wordpress.sql .

#Adding permission to the scripts
RUN chmod +x init_docker.sh
RUN chmod +x init_mysql.sh
RUN chmod +x start.sh

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Getting live 
CMD ./init_docker.sh
EXPOSE 3306
