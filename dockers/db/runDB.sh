#!/bin/bash

#run in daemon mode
docker run --rm --name mariadb -h db.jpbourbon-httpspeed.io \
--network speednet --ip 172.28.5.18 \
-p 3306:3306 -e MYSQL_ROOT_PASSWORD=http_speed_quic -d mariadb:10.3.13

sleep 10
docker exec -it mariadb mysql -uroot -phttp_speed_quic -e "create database httpcompare"
