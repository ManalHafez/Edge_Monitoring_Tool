#!/bin/bash

##Create Dedicated Network##
docker network create protexai-net
################################################################################
##Create a time-series DB##

##Create self-signed certificate to enable TLS in InfluxDB##
#openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/influxdb-selfsigned.key -out /etc/ssl/influxdb-selfsigned.crt -days 365

##Start InfluxDB as a Docker Container with TLS enabled##
docker run -d \
    --network protexai-net \
    -p 8086:8086 --name influxdb2 \
    -v "./data_source/data:/var/lib/influxdb2" \
    -v "./data_source/config:/etc/influxdb2" \
    -v "./data_source/certs/:/etc/ssl/certs/" \
    -e INFLUXD_TLS_CERT=/etc/ssl/certs/influxdb-selfsigned.crt \
    -e INFLUXD_TLS_KEY=/etc/ssl/certs/influxdb-selfsigned.key \
    influxdb:2

##Set the influxDB parameters##
USERNAME=mon ##Monitoring user that has access to the data bucket
PASSWORD=M0nitor123
ORGANIZATION=protexai
BUCKET=metrics

##Wait for the influxDB to startup##
sleep 5

##Setup the influxDB##
docker exec influxdb2 influx setup \
--host https://influxdb2:8086 \
--username $USERNAME \
--password $PASSWORD \
--org $ORGANIZATION --bucket $BUCKET \
--force --skip-verify ##Skip verify is required with self-signed certificates

##Save the mon user API token (Required to communicate with Grafana and the edge-device)##
mon_token=$(docker container exec influxdb2 influx auth list --skip-verify |grep "mon's" | awk '{print $4}')

echo $mon_token
##Command to start an intercative bash session with influxDB2 for troubleshooting##
#docker exec -it influxdb2 bash
################################################################################
##Create a data visualization system##

##Create self-signed certificate to enable TLS in Grafana##
#openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/influxdb-selfsigned.key -out /etc/ssl/influxdb-selfsigned.crt -days 365

##Start grafana as a socker container and set the admin password##
docker run -d --name=grafana --network protexai-net \
-e GF_SECURITY_ADMIN_PASSWORD=admin123 \
-e GF_SERVER_PROTOCOL=https \
-e GF_SERVER_HTTP_PORT=3000 \
-v ./data_visualizer/dashboard/:/etc/grafana/provisioning/dashboards \
-v ./data_visualizer/dashboard:/var/lib/grafana/dashboards \
-v ./data_visualizer/certs/:/etc/grafana/certs/ \
-e GF_SERVER_CERT_FILE=/etc/grafana/certs/grafana-selfsigned.crt \
-e GF_SERVER_CERT_KEY=/etc/grafana/certs/grafana-selfsigned.key \
-p 3000:3000 grafana/grafana

##Set the API token value in the influxdb configurations file##
cp ./data_visualizer/influxdb_source.yaml ./data_visualizer/influxdb.yaml
sed -i "s/new_token/$mon_token/g" ./data_visualizer/influxdb.yaml

##Copy the influxDB configurations file to Grafana container##
docker container cp ./data_visualizer/influxdb.yaml grafana:/etc/grafana/provisioning/datasources/influxdb.yaml
################################################################################
##Create the edge device##

##Set the API token value in the metric collection script##
cp ./data_collection_transfer/scripts/collect_metric_source.sh ./data_collection_transfer/scripts/collect_metric.sh
sed -i "s/new_token/$mon_token/g" ./data_collection_transfer/scripts/collect_metric.sh

##Build the docker image for the edge-device##
cd ./data_collection_transfer/
docker build -t edge-device:v1 .

##Create an edge device from the image##
docker container run -itd --network protexai-net --name edge-device edge-device:v1
################################################################################