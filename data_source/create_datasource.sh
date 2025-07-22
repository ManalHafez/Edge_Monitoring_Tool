#!/bin/bash

##Create Dedicated network##
#docker network create protexai-net

##Start InfluxDB manually as a Docker Container:
docker run -d \
    --network protexai-net \
    -p 8086:8086 --name influxdb2 \
    -v "$PWD/data:/var/lib/influxdb2" \
    -v "$PWD/config:/etc/influxdb2" \
    -v "$PWD/influxdb-selfsigned.key:/etc/ssl/influxdb-selfsigned.key" \
    -v "$PWD/influxdb-selfsigned.crt:/etc/ssl/influxdb-selfsigned.crt" \
    -e INFLUXD_TLS_CERT=/etc/ssl/influxdb-selfsigned.crt \
    -e INFLUXD_TLS_KEY=/etc/ssl/influxdb-selfsigned.key \
    influxdb:2

USERNAME=mon
PASSWORD=M0nitor123
ORGANIZATION=protexai
BUCKET=metrics

docker exec influxdb2 influx setup \
  --username $USERNAME \
  --host https://localhost:8086 \
  --password $PASSWORD \
  --org $ORGANIZATION \
  --bucket $BUCKET \
  --force --skip-verify

mon_token=$(docker container exec influxdb2 influx auth list --skip-verify |grep "mon's" | awk '{print $4}')
#docker exec -it influxdb2 bash

#Command used to create Key & Certificate files
#openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/influxdb-selfsigned.key -out /etc/ssl/influxdb-selfsigned.crt -days 365
