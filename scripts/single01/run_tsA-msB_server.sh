
http_version=$1
s=$2

ms=B
port=8000
servername=msb.jpbourbon-httpspeed.io
ts=A
host=msc.jpbourbon-httpspeed.io
port_con=8001
ip=192.168.1.7

name="$ms-$ts-$s"
docker run --rm -d -p 8000:8000 -p 8000:8000/udp --name $name -h $servername \
--network host \
--add-host server:$ip \
--security-opt="seccomp=unconfined"  \
--security-opt="label=disable" \
--privileged \
--cap-add=ALL \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e TS=$ts -e S=$s \
-e HOST=$host -e PORT_CON=$port_con -e HOST=$host -e SERVERNAME=$servername -e IPSERVER=$ip  -it http-min-speed-hybrid
