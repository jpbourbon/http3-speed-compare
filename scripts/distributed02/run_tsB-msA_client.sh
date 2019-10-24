#!/bin/bash

#--name name for container
# -h for hostname in docker
#--add-host to the mapping between name and ip. (avoid compiling the program)
# -v to bind volume
http_version=$1
s=$2
ms=A
port=8000
ts=B
dbhost=db.jpbourbon-httpspeed.io
dbport=3306
dbuser=root
dbpass=http_speed_quic
dbname=httpcompare
delay=1s
host=msb.jpbourbon-httpspeed.io
id=$3

name="$ms-$ts-$s-$id"
docker run --rm --name $name -h msa.jpbourbon-httpspeed.io$id \
--network speed_overlay \
--ip=172.28.254.9 \
--security-opt="seccomp=unconfined"  \
--security-opt="label=disable" \
--privileged \
--cap-add=ALL \
-e HTTP_VERSION=$http_version \
-e MS=$ms -e PORT=$port -e TS=$ts -e S=$s -e DBHOST=$dbhost -e DBPORT=$dbport -e DBUSER=$dbuser -e DBPASS=$dbpass -e DELAY=$delay \
-e DBNAME=$dbname -e HOST=$host -i http-min-speed-client
