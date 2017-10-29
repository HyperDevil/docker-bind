#!/bin/bash
/etc/init.d/bind9 start
/opt/getdns/bin/stubby -C /opt/getdns/etc/stubby/stubby.yml -v 2
