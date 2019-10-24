
#docker network create \
#  --driver=bridge \
#  --subnet=172.28.5.0/24 \
#  --ip-range=172.28.5.1/24 \
#  --gateway=172.28.5.254 \
#  speednet

http_version=$1
ms=B
port=8000
ts=B
s=$2
host=msb.jpbourbon-httpspeed.io

name="$ms-$ts-$s"
docker run --rm -d -p 8000:8000 -p 8000:8000/udp --name $name -h msb.jpbourbon-httpspeed.io \
--network host \
--security-opt="seccomp=unconfined"  \
--security-opt="label=disable" \
--privileged \
--cap-add=ALL \
-e HTTP_VERSION=$http_version -e MS=$ms -e PORT=$port -e TS=$ts -e S=$s \
-e HOST=$host -e SERVERNAME=$host -it http-min-speed-server
