# docker pull influxdb

# configuration (single step)
#docker run --rm influxdb influxd config > influxdb/influxdb.conf

docker run --rm -d --name influxdb -h influx.jpbourbon-httpspeed.io -p 8086:8086 -p 8083:8083 \
      --network speednet --ip 172.28.5.17 \
      -v $PWD/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
      influxdb -config /etc/influxdb/influxdb.conf

sleep 5
# Only one time, before running cadvisor
#curl -X POST -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE cadvisor"
