
http_version=$1
s=$2

ms=C
port=8001
ts=A
host=msd.jpbourbon-httpspeed.io
servername=msc.jpbourbon-httpspeed.io
port_con=8002

name="$ms-$ts-$s"

docker run --rm -d -p 8001:8001 -p 8001:8001/udp --name $name -h $servername \
--network speed_overlay \
--ip=172.28.254.13 \
--security-opt="seccomp=unconfined"  \
--security-opt="label=disable" \
--privileged \
--cap-add=ALL \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e TS=$ts -e S=$s \
-e HOST=$host -e PORT_CON=$port_con -e HOST=$host -e SERVERNAME=$servername  -it http-min-speed-hybrid
