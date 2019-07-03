#!/bin/sh

openssl req -newkey rsa:2048 -nodes -x509 -days 365 \
	-keyout key.pem -out cert.pem \
	-subj "/C=CN/ST=ZJ/L=HZ/O=NetEase/OU=DEV/CN=163.com/emailAddress=hzmingcheng@crop.netease.com"

