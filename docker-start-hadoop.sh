#!/bin/bash

#tmux

echo "Starting Apache Hadoop $HAHOOP_VERSION ..."
if [[ $APACHE_HADOOP_SITE_HOSTNAME == "localhost" ]]; then
  export APACHE_HADOOP_SITE_HOSTNAME="$(hostname)"
  echo "Changed Host name :  $APACHE_HADOOP_SITE_HOSTNAME"
fi
if [[ "yes" != "$APACHE_HADOOP_IS_CLUSTER" ]]; then
  sed s/HOSTNAME/$APACHE_HADOOP_SITE_HOSTNAME/ $HADOOP_HOME/etc/hadoop/singlenode/core-site.xml.template | sed s/BUFFERSIZE/$APACHE_HADOOP_SITE_BUFFER_SIZE/ > $HADOOP_HOME/etc/hadoop/core-site.xml
else
  sed s/HOSTNAME/$APACHE_HADOOP_SITE_HOSTNAME/ $HADOOP_HOME/etc/hadoop/clusternode/core-site.xml.template | sed s/BUFFERSIZE/$APACHE_HADOOP_SITE_BUFFER_SIZE/ > $HADOOP_HOME/etc/hadoop/core-site.xml
fi
if ! [[ -e /root/hadoop_configured ]]; then
  echo "Configuring Apache Hadoop $HAHOOP_VERSION ..."
  echo "Host name :  $APACHE_HADOOP_SITE_HOSTNAME"
  mkdir -p /user/$HADOOP_USER/data/hadoop/hdfs/namenode
  mkdir -p /user/$HADOOP_USER/data/hadoop/hdfs/checkpoint
  mkdir -p /user/$HADOOP_USER/data/hadoop/hdfs/datanode
  echo -e "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR\nexport YARN_CONF_DIR=$YARN_CONF_DIR\nexport HADOOP_USER=$HADOOP_USER\nexport HDFS_NAMENODE_USER=$HADOOP_USER\nexport HDFS_DATANODE_USER=$HADOOP_USER\nexport YARN_RESOURCEMANAGER_USER=$HADOOP_USER\nexport YARN_NODEMANAGER_USER=$HADOOP_USER\nexport HDFS_SECONDARYNAMENODE_USER=$HADOOP_USER" >> /root/.bashrc
  echo -e "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> /root/.bashrc
  source /root/.bashrc

  if [[ "yes" != "$APACHE_HADOOP_IS_CLUSTER" ]]; then
    echo "Configuring Apache Hadoop $HAHOOP_VERSION Single Node ..."
    touch $HADOOP_HOME/etc/hadoop/core-site.xml
    sed s/USERNAME/$HADOOP_USER/ $HADOOP_HOME/etc/hadoop/singlenode/hdfs-site.xml.template > $HADOOP_HOME/etc/hadoop/hdfs-site.xml
#    cp $HADOOP_HOME/etc/hadoop/singlenode/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
    cp $HADOOP_HOME/etc/hadoop/singlenode/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
    cp $HADOOP_HOME/etc/hadoop/singlenode/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
  else
    if [[ "no" != "$APACHE_HADOOP_IS_CLUSTER" ]]; then
      echo "Invalid cluster flag preference : $APACHE_HADOOP_IS_CLUSTER\nExpected: (yes/no) found : $APACHE_HADOOP_IS_CLUSTER"
      exit 1
    fi
    echo "Configuring Apache Hadoop $HAHOOP_VERSION Cluster Node ..."
    touch $HADOOP_HOME/etc/hadoop/core-site.xml
    touch $HADOOP_HOME/etc/hadoop/hdfs-site.xml
    sed s/HOSTNAME/$APACHE_HADOOP_SITE_HOSTNAME/ $HADOOP_HOME/etc/hadoop/clusternode/core-site.xml.template | sed s/BUFFERSIZE/$APACHE_HADOOP_SITE_BUFFER_SIZE/ > $HADOOP_HOME/etc/hadoop/core-site.xml
    sed s/REPLICATION/$APACHE_HADOOP_HDFS_REPLICATION/ $HADOOP_HOME/etc/hadoop/clusternode/hdfs-site.xml.template | sed s/USERNAME/$HADOOP_USER/ > $HADOOP_HOME/etc/hadoop/hdfs-site.xml
    cp $HADOOP_HOME/etc/hadoop/singlenode/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
    cp $HADOOP_HOME/etc/hadoop/singlenode/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
fi
  if [[ -e /usr/share/zoneinfo/$MACHINE_TIMEZONE ]]; then
    ln -fs /usr/share/zoneinfo/$MACHINE_TIMEZONE /etc/localtime
    echo "Current Timezone: $(cat /etc/timezone)"
    dpkg-reconfigure tzdata
  fi

  service ssh start
  $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  $HADOOP_HOME/bin/hdfs namenode -format -force -nonInteractive && \
  $HADOOP_HOME/sbin/start-dfs.sh && \
  $HADOOP_HOME/bin/hdfs dfs -mkdir /user && \
  $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root && \
  $HADOOP_HOME/sbin/stop-dfs.sh
  service ssh stop

  service ssh start
  $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  $HADOOP_HOME/sbin/start-dfs.sh && \
  $HADOOP_HOME/bin/hdfs dfs -mkdir input && \
  $HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/ input && \
  $HADOOP_HOME/sbin/stop-dfs.sh
  service ssh stop
  touch /root/hadoop_configured
else
  echo "Apache Hadoop $HAHOOP_VERSION already configured!!"
fi

if [[ $1 == "-daemon" ]]; then
  /etc/bootstrap.sh -d
else
  if [[ $1 == "-interactive" ]]; then
    /etc/bootstrap.sh -bash
  else
    echo "docker-start-hadoop [mode]"
    echo "-daemon Start with infinite listener"
    echo "-interactive Start with bash shell"
    exit 1
  fi
fi
