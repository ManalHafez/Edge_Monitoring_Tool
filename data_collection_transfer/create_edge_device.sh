#!/bin/bash
docker build -t edge-device:v1 .
docker container run -itd --network protexai-net --name edge-device edge-device:v1
