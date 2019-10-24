#!/bin/bash

DIR_CONF="/Zdata/Qdeveloper/UAB/MISE_JoaoBourbon/http3-speed-compare/zconf/bind/"

docker run --rm --name bind9 -p 53:53 -p 53:53/udp \
-v $DIR_CONF/named.conf.options:/etc/bind/named.conf.options \
-v $DIR_CONF/named.conf.local:/etc/bind/named.conf.local \
-v $DIR_CONF/named.conf.default-zones:/etc/bind/named.conf.default-zones \
-v $DIR_CONF/named.conf.log:/etc/bind/named.conf.log \
-v $DIR_CONF/named.conf:/etc/bind/named.conf \
-v $DIR_CONF/rndc.key:/etc/bind/rndc.key \
-v $DIR_CONF/db.root:/etc/bind/db.root \
-v $DIR_CONF/db.local:/etc/bind/db.local \
-v $DIR_CONF/db.jpbourbon-httpspeed.io:/etc/bind/db.jpbourbon-httpspeed.io \
-v $DIR_CONF/db.jpbourbon-httpspeed.io:/etc/bind/db.jpbourbon-httpspeed.io \
-v $DIR_CONF/db.empty:/etc/bind/db.empty \
-v $DIR_CONF/db.255:/etc/bind/db.255 \
-v $DIR_CONF/db.192.168:/etc/bind/db.192.168 \
-v $DIR_CONF/db.127:/etc/bind/db.127 \
-v $DIR_CONF/db.0:/etc/bind/db.0 \
-v $DIR_CONF/bind.keys:/etc/bind/bind.keys \
--cap-add NET_BIND_SERVICE \
 resystit/bind9:latest

