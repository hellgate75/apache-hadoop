FROM ubuntu:16.04

MAINTAINER Fabrizio Torelli (hellgate75@gmail.com)

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1

ENV APACHE_HADOOP_IS_CLUSTER=no \
    APACHE_HADOOP_IS_MASTER=no \
    APACHE_HADOOP_HDFS_REPLICATION=1 \
    APACHE_HADOOP_SITE_HOSTNAME=localhost \
    APACHE_HADOOP_SITE_BUFFER_SIZE=131072 \
    MACHINE_TIMEZONE="Europe/Dublin" \
    DEBIAN_FRONTEND=noninteractive \
    JAVA_VERSION=8u131 \
    JAVA_RELEASE=b11 \
    HAHOOP_VERSION=3.0.0-alpha3 \
    JAVA_HOME=/usr/java/default \
    PATH=$PATH:$JAVA_HOME/bin \
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
    JAVA_HOME=/usr/java/default \
    HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    HDFS_NAMENODE_USER=root \
    HDFS_DATANODE_USER=root \
    YARN_RESOURCEMANAGER_USER=root \
    YARN_NODEMANAGER_USER=root \
    HDFS_SECONDARYNAMENODE_USER=root \
    PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin \
    BASH_ENV=/etc/profile




USER root

#RUN dpkg --force-help && exit 1

RUN echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
  echo "deb http://mirror.math.princeton.edu/pub/ubuntu trusty main universe" >> /etc/apt/sources.list && \
  apt-get update -q -y && \
  apt-get dist-upgrade -y && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && apt-get -q -y install apt-utils && apt-get -q -y -o Dpkg::Options::="--force-confold,overwrite,confdef" \
  install --no-install-recommends wget curl tar sudo openssh-client rsync build-essential

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
  ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN apt-get -q -y -o Dpkg::Options::="--force-confold,overwrite,confdef" install --no-install-recommends openssh-server ca-certificates openssl rpm \
    python-pip python-sklearn python-pandas python-numpy python-matplotlib software-properties-common python-software-properties ssh pdsh net-tools tmux
    # this latest package makes available add-apt-repository commnd

RUN add-apt-repository -y ppa:webupd8team/java && \
    apt-get update -q && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y oracle-java8-installer && \
    mkdir -p /usr/java && \
    ln -s /usr/lib/jvm/java-8-oracle /usr/java/default && \
    echo "===> clean up..."  && \
    rm -rf /var/cache/apt/archives/*.deb  && \
    apt-get -y autoremove  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

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
    echo "Port 2122" >> /etc/ssh/sshd_config

WORKDIR $HADOOP_HOME


CMD ["docker-start-hadoop", "-daemon"]

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
