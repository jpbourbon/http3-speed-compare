#!/bin/bash

#--name name for container
# -h for hostname in docker
#--add-host to the mapping between name and ip. (avoid compiling the program)
# -v to bind volume
http_version=3
ms=A
port=8000
ts=B
s=2
dbhost=""
dbuser=""
dbpass=""
delay=1
host=msb.jpbourbon-httpspeed.io

name="$ms-$ts-$s"
docker run --rm --name $name -h msa.jpbourbon-httpspeed.io --add-host server:172.28.5.20 \
--add-host msb.jpbourbon-httpspeed.io:172.28.5.20 \
--add-host msa.jpbourdon-httpspeed.io:172.28.5.19 \
--add-host db.jpbourbon-httpspeed.io:172.28.5.18 \
--network speednet \
--ip 172.28.5.19 \
-e HTTP_VERSION=$http_version \
-e MS=$ms -e PORT=$port -e TS=$ts -e S=$s -e DBHOST=$dbhost -e DBPORT=3306 -e DBUSER=$dbuser -e DBPASS=$dbpass -e DELAY=$delay \
-e HOST=$host -it http-speed-client ./runHttpClient.sh
