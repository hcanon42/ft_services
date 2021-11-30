#!/bin/sh

#Starting the SSH deamon, Telegraf and nginx
/usr/sbin/sshd
telegraf &
/usr/sbin/nginx -g 'daemon off;'
