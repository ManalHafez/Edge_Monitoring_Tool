# Edge_Monitoring_Tool [In-progress]
Edge Device Hardware Monitoring Tool
This project simulate a monitoring tool for edge devices.

Assumptions:
-The edge devices run Linux (Ubuntu 22.04) and have internet access.
-The data collection and transfer rate is 60 seconds

The project has three components:
1. Edge device:
- Represented in the "data_collection_transfer" component.
- Scripts & scheduling files can be copied to the node directly.
- I have created a docker file with the scripts to simulate the edge device.
- The scripts will collect the main metrics, write them to a local metric file and also send them to an external datasource.
- No administrative access required for the user running the scripts.
- The script uses awk, curl, df and top commands which are availbale in most linux servers with no additional package installation requirements.

2. External DataSource
- Represented in the "data_source" component.
- I believe the best option is to use a streaming, queue system or a time-series DB.
- In this example I used InfluxDB(time-series DB), that receives the data from the script running on the node.
- The DB can be used to any Data visualization tool.
- I have enable TLS and tokens are used to authenticate the client with the DB.

3. Data Visualization
- Represented in the "data_visualizer" component.
- To create dashboards, I used Grafana. In this case it is easy to setup and integrate with InfluxDB.
- It also allows creating centralized alarms for any metric in the dashboard.
