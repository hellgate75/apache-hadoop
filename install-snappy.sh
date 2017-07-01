#!/bin/bash
cd /opt
echo "Apache™ Hadoop® updating references ...."
add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse" && \
sort /etc/apt/sources.list | uniq > /etc/apt/sources.list && \
apt-get update && \
wget https://cmake.org/files/v3.9/cmake-3.9.0-rc5-Linux-x86_64.sh -O cmake-install.sh && \
chmod 777 ./cmake-install.sh && \
mkdir /usr/local/cmake && \
./cmake-install.sh  --prefix=/usr/local/cmake --exclude-subdir &&\
rm -f ./cmake-install.sh && \
apt-get clean && \
apt-get -y autoclean && \
rm -rf /var/lib/apt/lists/*
echo "Apache™ Hadoop® downloading SnapPy ...."
wget https://codeload.github.com/google/snappy/legacy.tar.gz/master -O snappy.tgz
echo "Apache™ Hadoop® de-compressing SnapPy ...."
tar -xzf ./snappy.tgz
cd google-snappy-*
mkdir build
echo "Apache™ Hadoop® installing SnapPy ...."
cd build && cmake ../ && make
make install
echo "Apache™ Hadoop® linking SnapPy ...."
ln -s /usr/local/lib/libsnappy.so $HADOOP_HOME/lib/native/libsnappy.so.1
