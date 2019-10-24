
http_version=$1
s=$2

ms=D
port=8002
ts=A
host=msd.jpbourbon-httpspeed.io
servername=msd.jpbourbon-httpspeed.io

name="$ms-$ts-$s"
docker run --rm -d -p 8002:8002 -p 8002:8002/udp --name $name -h $servername \
--network host \
--security-opt="seccomp=unconfined"  \
--security-opt="label=disable" \
--privileged \
--cap-add=ALL \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e TS=$ts -e S=$s \
-e HOST=$host -e SERVERNAME=$host -it http-min-speed-server
