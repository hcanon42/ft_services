FROM alpine:latest
ARG IP

#Installing essential packages
RUN	apk update && \
	apk add openrc --no-cache && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache && \
	apk add pure-ftpd --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

#Creating new user
RUN { echo "password"; echo "password"; } | adduser user

#Saving the minikube IP given at build time
RUN echo ${IP} > ip.txt

#Setting up Telegraf config
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

#Writing up the welcome message :)
RUN echo 'Welcome to FTP' > /hello.txt

#Getting live !
COPY ./start.sh /start.sh

CMD sh /start.sh
EXPOSE 21 21000
