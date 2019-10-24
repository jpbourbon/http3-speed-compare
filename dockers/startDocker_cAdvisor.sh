
sudo docker run --rm \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --network speednet \
  --ip 172.28.5.16 \
  google/cadvisor:latest -storage_duration=30m0s \
    -storage_driver_buffer_duration=1m0s -allow_dynamic_housekeeping=false \
    -global_housekeeping_interval=1m0s -housekeeping_interval=1s \
    -max_housekeeping_interval=1m0s -alsologtostderr=true \
    -storage_driver=influxdb -storage_driver_host=172.28.5.17:8086  -storage_driver_db=cadvisor
