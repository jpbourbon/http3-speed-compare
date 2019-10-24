#!/bin/bash

DIR_CONF="/Zdata/Qdeveloper/UAB/MISE_JoaoBourbon/http3-speed-compare/zconf/chrony/"

#-v $DIR_CONF/chrony.conf:/etc/ntp.conf:ro \

docker run -p 123:123 -p 123:123/udp  \
-v $DIR_CONF/ntp.conf:/etc/ntpd.conf:ro \
--name=ntp             \
--rm \
--detach=true          \
--cap-add=SYS_NICE     \
--cap-add=SYS_RESOURCE \
--cap-add=SYS_TIME     \
--cap-add=NET_BIND_SERVICE \
--net=host \
-d cturra/ntp 

#--net=speednet \
