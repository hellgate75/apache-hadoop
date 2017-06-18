#!/bin/bash

: ${HADOOP_HOME:=/usr/local/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service ssh start

mkdir -p $HADOOP_HOME/logs

$HADOOP_HOME/sbin/stop-all.sh && \
$HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
$HADOOP_HOME/bin/hdfs namenode -format -force -nonInteractive && \
$HADOOP_HOME/sbin/start-all.sh

sleep 30
netstat aux

if [[ $1 == "-d" ]]; then
  tail -f /dev/null
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
