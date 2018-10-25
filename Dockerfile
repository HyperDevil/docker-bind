FROM debian:stretch-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    bash \
    bind9 \
    wget \
    automake \
    make \
    gcc \
    build-essential \
    libunbound-dev \
    libldns-dev \
    autoconf \
    libevent-dev \
    libuv1-dev \
    libev-dev \
    libssl-dev \
    libidn11-dev \
    libyaml-dev \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    mkdir -p /tmp/src/getdns && \
    cd /tmp/src/getdns && \
    wget -O getdns.tar.gz https://getdnsapi.net/releases/getdns-1-2-0/getdns-1.2.0.tar.gz && \
    tar xzf getdns.tar.gz && \
    rm -f getdns.tar.gz && \
    cd getdns-1.2.0 && \
    groupadd getdns && \
    useradd -g getdns -s /etc -d /dev/null getdns && \
    ./configure --prefix=/opt/getdns --with-stubby --build=x86_64 --host=x86_64 --target=x86_64 &&\
    make && \
    make install && \
    rm -rf /tmp/* && \
    mkdir -p /opt/getdns/var/run/ && \
    chmod 777 /opt/getdns/var/run/

RUN set -x && \
   curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 > /usr/sbin/gosu && \
   chmod +x /usr/sbin/gosu


COPY stubby.yml /opt/getdns/etc/stubby/stubby.yml
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local

EXPOSE 53

COPY entrypoint.sh /opt/
RUN chmod 777 /opt/entrypoint.sh

CMD ["/bin/bash","/opt/entrypoint.sh"]
