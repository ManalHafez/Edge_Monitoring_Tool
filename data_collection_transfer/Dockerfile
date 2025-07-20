FROM ubuntu:22.04
RUN apt-get update -y && apt-get install curl -y
COPY scripts /home/mon/
COPY scheduling/*.service /etc/systemd/system/
