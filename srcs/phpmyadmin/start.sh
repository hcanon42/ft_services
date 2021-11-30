#!/bin/sh

#Launching Telegraf and a simple PHP web server serving PHPMyAdmin interface
telegraf &
php -S 0.0.0.0:5000 -t /www/
