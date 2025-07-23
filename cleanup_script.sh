#!/bin/bash

docker stop grafana influxdb2 edge-device

docker rm grafana influxdb2 edge-device

docker image rm edge-device:v1 grafana/grafana:latest influxdb:2

docker network rm protexai-net

rm -rf ./data_source/data/ ./data_source/config/
