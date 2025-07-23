#!/bin/bash

#output_dir=/home/mon/metrics/
output_dir=/tmp/monitor/metrics/
mkdir -p $output_dir
output_file=$output_dir/$(date +%Y%m%d_%H)

##Hostname##
node=$('hostname')

##Local Date & Time Stamp##
time_stamp=$(date +%Y%m%d_%H%M%S)

##Memory Utilization##
mem_util=$(top -bn1 | grep "MiB Mem" | awk '{print $8*100/$4}')
mem=$(top -bn1 | grep "MiB Mem" | awk '{print "Total Mem: " $4 "MB, Used Mem: ", $8}')

##CPU Utilization##
cpu_util=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}')
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print "User CPU: " $2 "%, System CPU: " $4 "%, Idle CPU: " $8 "%"}')

##Disk Utilization##
disk_util=$(df -h | grep "/$" | awk '{print $3/$2}')
disk=$(df -h | grep "/$" | awk '{print "Total Root: " $2 ", Root Usage: " $5}')

##Update Local Metrics File [Optional]##
echo "$time_stamp, $node, $mem, $cpu, $disk" >> $output_file

##Send the metrics to external data source##
curl -k --request POST "https://influxdb2:8086/api/v2/write?org=protexai&bucket=metrics&precision=s" --header "Authorization: Token new_token" --data-raw "metrics,host=${HOSTNAME} memory="${mem_util}",cpu=${cpu_util},disk=${disk_util}"

##Sample output: metrics,host=myhost memory=23.5,cpu=65.2,disk=80.1
