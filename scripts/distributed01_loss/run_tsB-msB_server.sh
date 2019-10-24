
http_version=$1
ms=B
port=8000
ts=B
s=$2
host=msb.jpbourbon-httpspeed.io
ip=192.168.1.12

name="$ms-$ts-$s"
docker run --rm -d -p 8000:8000 -p 8000:8000/udp --name $name -h msb.jpbourbon-httpspeed.io \
--network host \
--add-host server:$ip \
--security-opt="seccomp=unconfined"  \
--security-opt="label=disable" \
--privileged \
--cap-add=ALL \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e TS=$ts -e S=$s \
-e HOST=$host -e SERVERNAME=$host -e IPSERVER=$ip -it http-min-speed-server
