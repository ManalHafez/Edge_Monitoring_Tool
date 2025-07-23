# Edge_Monitoring_Tool
Edge Device Hardware Monitoring Tool
This project simulate a monitoring tool for edge devices.

- Installation and run instructions:

#cd Edge_Monitoring_Tool/

#chmod u+x startup_script.sh cleanup_script.sh

To startup the tool and create the full setup:

#./startup.sh

To access Grana GUI --> https://localhost:3000/ (username: admin, password: admin123)

To access InfluxDB GUI --> https://localhost:8086/ (username: mon, password: M0nitor123)

To cleanup the setup:

#./cleanup.sh

Assumptions:
- The client (where you will run the tool) has docker & Linux installed.
- All the required ports are availble in the host (port 3000 & 8086)
-The edge devices run Linux (Ubuntu 22.04).
- The data collection and transfer rate is 60 seconds.
- All the edge devices are managed by AWS IOT core and GreenGrass.

Demo Link: https://www.loom.com/share/367b3698b67c46988d07dddb5d8c38d0?sid=3b70a59c-3e12-4794-9d13-5872eb466020
