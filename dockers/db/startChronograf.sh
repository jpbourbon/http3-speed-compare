# docker pull influxdb

# configuration (single step)
#docker run --rm influxdb influxd config > influxdb/influxdb.conf

docker run --rm -d --name chronograf -h chronograf.jpbourbon-httpspeed.io -p 8080:8080 \
      --network speednet --ip 172.28.5.14 \
      -v $PWD/chronograf/chronograf.conf:/etc/chronograf/chronograf.conf:ro \
      chronograf --influxdb-url=http://172.28.5.17:8086 --host=0.0.0.0 --port=8080

sleep 5
# Only one time, before running cadvisor
