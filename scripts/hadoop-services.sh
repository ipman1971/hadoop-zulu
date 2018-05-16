#!/bin/bash

echo "RUN service ssh start"
service ssh start

echo "HADOOP SERVICES"
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

echo "Get basic filesystem information and statistics."
hdfs dfsadmin -report
