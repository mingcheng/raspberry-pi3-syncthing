# Syncthing for Raspberry Pi

This is a Syncthing docker images for Raspberry Pi platform.

## Setup

This project include docker-compose configure file. So you can deply it with command:

```
docker-compose up
```

That's it!

## Discovery Server

First, generate new SSL key using `./genkey.sh`, then we have two files which names `cert.pem` and `key.pem`. Then running using docker-compose!

## Links

* https://syncthing.net
* https://github.com/yobasystems/alpine-syncthing
* https://docs.syncthing.net/users/stdiscosrv.html
