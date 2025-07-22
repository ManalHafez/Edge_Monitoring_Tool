#!/bin/bash
docker run -d --name=grafana --network protexai-net -e GF_SECURITY_ADMIN_PASSWORD=admin123 -p 3000:3000 grafana/grafana
docker container cp ./influxdb.yaml grafana:/etc/grafana/provisioning/datasources/influxdb.yaml

