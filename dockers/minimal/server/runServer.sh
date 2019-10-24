#!/bin/bash

#--name name for container
# -h for hostname in docker
#--add-host to the mapping between name and ip. (avoid compiling the program)
# -v to bind volume
http_version=3
ms=B
port=8000
ts=B
s=1

name="$ms-$ts-$s"
docker run --rm -p 8002:8002 -p 8002:8002/udp --name $name -h $name --add-host server:172.17.0.20 --ip 172.17.0.20 \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e TS=$ts -e S=$s -it http-min-speed-server ./runHttpServ.sh
