#!/bin/bash

##Cleanup logs older than a month##
find /home/mon/logs/ -mtime +30 -exec rm "{}" \; 

##Cleanup metrics older than a month##
find /home/mon/metrics/ -mdate +30 -exec rm "{}" \;
