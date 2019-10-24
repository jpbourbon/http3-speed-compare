# docker pull influxdb

# configuration (single step)
#docker run --rm influxdb influxd config > influxdb/influxdb.conf

docker run --rm -d --name telegraf -h telegraf.jpbourbon-httpspeed.io  \
      --network speednet --ip 172.28.5.15 \
      -v $PWD/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
      -v /var/run/docker.sock:/var/run/docker.sock:ro -v /sys:/rootfs/sys:ro -v /proc:/rootfs/proc:ro -v /etc:/rootfs/etc:ro \
      -v /var/run/httpspeed:/var/run/httpspeed:ro \
      telegraf --debug

sleep 5
# Only one time, before running cadvisor
