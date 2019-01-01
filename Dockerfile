FROM resin/raspberry-pi-alpine:3.7
LABEL maintainer "Ming Chen<mingcheng@outlook.com>" architecture="ARM32v7/armhf" version="1.0.0"

ENV SYNCTHING_VERSION=1.0.0 \
    SYNCTHING_USERID=1000 \
    SYNCTHING_GROUPID=1000 \
    GOSU_VERSION=1.11 \
    STNOUPGRADE=true

WORKDIR /

# Prerequisites
#RUN apk update && apk upgrade 

RUN cd /tmp &&\
    apk -U add openssl gnupg && \
    echo "Getting GPG keys for gosu and Syncthing" && \
    gpg-agent --daemon && \
    gpg --quiet --keyserver hkp://keyserver.ubuntu.com:80  --recv-keys 37C84554E7E0A261E4F76E1ED26E6ED000654A3E B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    echo "Getting gosu and its signature" && \
    wget -q https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf.asc && \
    wget -q https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf &&\
    echo "Checking gosu signature" && \
    gpg --quiet --verify gosu-armhf.asc && \
    echo "Installing gosu" && \
    chmod +x gosu-armhf && mv gosu-armhf /bin/gosu 

RUN echo "Getting Syncthing and its signature" && \
    wget -q https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/sha1sum.txt.asc && \
    wget -q https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/syncthing-linux-arm-v${SYNCTHING_VERSION}.tar.gz && \
    echo "Checking gosu sha1 sum signature" && \
    gpg --quiet --verify sha1sum.txt.asc && \
    echo "Checking gosu sha1 checksum" && \
    grep syncthing-linux-arm-v${SYNCTHING_VERSION}.tar.gz sha1sum.txt.asc | sha1sum -c - && \
    echo "Installing syncthing" && \
    tar -xzf syncthing-linux-arm-v${SYNCTHING_VERSION}.tar.gz syncthing-linux-arm-v${SYNCTHING_VERSION}/syncthing && \
    mv syncthing-linux-arm-v${SYNCTHING_VERSION}/syncthing /bin/

RUN echo "Cleaning up" && \
    rm -rf /tmp/* && \
    rm -rf /root/* && \
    apk del gnupg openssl && \
    rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /config /syncthing

EXPOSE 8384 22000 21027/udp

HEALTHCHECK --interval=1m --timeout=10s \
CMD nc -z localhost 8384 || exit 1

VOLUME ["/syncthing"]

CMD ["/entrypoint.sh"]
