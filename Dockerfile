FROM hellgate75/ubuntu-base:16.04

MAINTAINER Fabrizio Torelli (hellgate75@gmail.com)

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1

ENV APACHE_HADOOP_IS_CLUSTER=no \
    APACHE_HADOOP_IS_MASTER=no \
    APACHE_HADOOP_HDFS_REPLICATION=1 \
    APACHE_HADOOP_HDFS_BLOCKSIZE=268435456 \
    APACHE_HADOOP_HDFS_HANDLERCOUNT=100 \
    APACHE_HADOOP_SITE_HOSTNAME=localhost \
    APACHE_HADOOP_SITE_BUFFER_SIZE=131072 \
    APACHE_HADOOP_YARN_RESOURCE_MANAGER_HOSTNAME=localhost \
    APACHE_HADOOP_YARN_ACL_ENABLED=false \
    APACHE_HADOOP_YARN_ADMIN_ACL=* \
    APACHE_HADOOP_YARN_AGGREGATION_RETAIN_SECONDS=60 \
    APACHE_HADOOP_YARN_AGGREGATION_RETAIN_CHECK_SECONDS=120 \
    APACHE_HADOOP_YARN_LOG_AGGREGATION=false \
    APACHE_HADOOP_MAPRED_JOB_HISTORY_HOSTNAME=localhost \
    APACHE_HADOOP_MAPRED_JOB_HISTORY_PORT=10020 \
    APACHE_HADOOP_MAPRED_JOB_HISTORY_WEBUI_HOSTNAME=localhost \
    APACHE_HADOOP_MAPRED_JOB_HISTORY_WEBUI_PORT=19888 \
    APACHE_HADOOP_MAPRED_MAP_MEMORY_MBS=1536 \
    APACHE_HADOOP_MAPRED_MAP_JAVA_OPTS="-Xmx1024M" \
    APACHE_HADOOP_MAPRED_RED_MEMORY_MBS=3072 \
    APACHE_HADOOP_MAPRED_RED_JAVA_OPTS="-Xmx2560M" \
    APACHE_HADOOP_MAPRED_SORT_MEMORY_MBS=512 \
    APACHE_HADOOP_MAPRED_SORT_FACTOR=100 \
    APACHE_HADOOP_MAPRED_SHUFFLE_PARALLELCOPIES=50 \
    MACHINE_TIMEZONE="Europe/Dublin" \
    DEBIAN_FRONTEND=noninteractive \
    HAHOOP_VERSION=3.0.0-alpha3 \
    HADOOP_HOME=/usr/local/hadoop \
    HADOOP_USER=root \
    HADOOP_COMMON_HOME=/usr/local/hadoop \
    HADOOP_HDFS_HOME=/usr/local/hadoop \
    HADOOP_MAPRED_HOME=/usr/local/hadoop \
    HADOOP_YARN_HOME=/usr/local/hadoop \
    HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    YARN_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    HDFS_NAMENODE_OPTS="-XX:+UseParallelGC -Xmx4g" \
    BOOTSTRAP=/etc/bootstrap.sh \
    NOTVISIBLE="in users profile" \
    HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    HDFS_NAMENODE_USER=root \
    HDFS_DATANODE_USER=root \
    YARN_RESOURCEMANAGER_USER=root \
    YARN_NODEMANAGER_USER=root \
    HDFS_SECONDARYNAMENODE_USER=root \
    PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/cmake/bin/ \
    BASH_ENV=/etc/profile

USER root

# download hadoop
RUN curl -L https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-$HAHOOP_VERSION/hadoop-$HAHOOP_VERSION.tar.gz | tar -xz -C /usr/local/ && \
    cd /usr/local && ln -s ./hadoop-$HAHOOP_VERSION hadoop && \
    sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/java/default\nexport HADOOP_HOME=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mkdir $HADOOP_HOME/input && cp $HADOOP_HOME/etc/hadoop/*.xml $HADOOP_HOME/input

ADD singlenode $HADOOP_HOME/etc/hadoop/singlenode
ADD clusternode $HADOOP_HOME/etc/hadoop/clusternode

RUN mkdir -p /root/.ssh && touch /root/.ssh/config && cat /root/.ssh/config
ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config && chown root:root /root/.ssh/config && mkdir /var/run/sshd && echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
# SSH login fix. Otherwise user is kicked off after login
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

COPY install-snappy.sh /etc/install-snappy.sh
RUN chmod 777 /etc/install-snappy.sh && /etc/install-snappy.sh && rm -f /etc/install-snappy.sh

# # installing supervisord
# RUN yum install -y python-setuptools
# RUN easy_install pip
# RUN curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -o - | python
# RUN pip install supervisor
#
# ADD supervisord.conf /etc/supervisord.conf
ADD bootstrap.sh /etc/bootstrap.sh
ADD docker-start-hadoop.sh /usr/local/bin/docker-start-hadoop
# fix the 254 error code
RUN chown root:root /etc/bootstrap.sh && chmod 700 /etc/bootstrap.sh && chown root:root /usr/local/bin/docker-start-hadoop && chmod 700 /usr/local/bin/docker-start-hadoop && \
    chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh && sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config && echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "Port 2122" >> /etc/ssh/sshd_config && mkdir -p /etc/config/hadoop && mkdir -p /etc/hadoop && ln -s /usr/local/hadoop-$HAHOOP_VERSION/etc/hadoop /etc/hadoop && rm -f $HADOOP_HOME/etc/hadoop/core-site.xml \
    $HADOOP_HOME/etc/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && touch $HADOOP_HOME/etc/hadoop/mapred-site.xml && touch $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    touch $HADOOP_HOME/etc/hadoop/yarn-site.xml && touch $HADOOP_HOME/etc/hadoop/core-site.xml

WORKDIR $HADOOP_HOME


CMD ["docker-start-hadoop", "-daemon"]

VOLUME ["/user/root/data/hadoop/hdfs/datanode", "/user/root/data/hadoop/hdfs/namenode", "/user/root/data/hadoop/hdfs/checkpoint", "/etc/config/hadoop"]

# Exposed ports
# HDFS ports :
# 50010 50020 50070 50075 50090 8020 9000
# MAP Reduce ports :
# 10020 19888
# YARN ports:
# 8030 8031 8032 8033 8040 8042 8088
# Other Apache Hadoop ports:
# 49707 2122
EXPOSE 50010 50020 50070 50075 50090 8020 9000 10020 19888 8030 8031 8032 8033 8040 8042 8088 49707 2122
