#!/bin/bash

#--name name for container
# -h for hostname in docker
#--add-host to the mapping between name and ip. (avoid compiling the program)
# -v to bind volume
http_version=3
ts=B
s=1

ms=B
port=8000
port_con=8001
ip=172.17.0.20
name="$ms-$ts-$s"
docker run --rm -p 8000:8000 -p 8000:8000/udp  --name $name -h $name --add-host server:$ip --ip $ip \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e PORT_CON=$port_con -e TS=$ts -e S=$s \
-it http-speed-server ./runHttpHybrid.sh

ms=C
port=8001
port_con=8002
ip=172.17.0.21
name="$ms-$ts-$s"
docker run --rm -p 8001:8001 -p 8001:8001/udp --name $name -h $name --add-host server:$ip --ip $ip \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e PORT_CON=$port_con -e TS=$ts -e S=$s \
-it http-speed-server ./runHttpHybrid.sh
