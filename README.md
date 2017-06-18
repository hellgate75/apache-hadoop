# Apache Hadoop Docker image


Docker Image for Apache Hadoop Single/Cluster Node


### Introduction ###

The Apache™ Hadoop® project develops open-source software for reliable, scalable, distributed computing.

The Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models. It is designed to scale up from single servers to thousands of machines, each offering local computation and storage. Rather than rely on hardware to deliver high-availability, the library itself is designed to detect and handle failures at the application layer, so delivering a highly-available service on top of a cluster of computers, each of which may be prone to failures.


The project includes these modules:

* Hadoop Common: The common utilities that support the other Hadoop modules.
* Hadoop Distributed File System (HDFS™): A distributed file system that provides high-throughput access to application data.
* Hadoop YARN: A framework for job scheduling and cluster resource management.
*  Hadoop MapReduce: A YARN-based system for parallel processing of large data sets.


Here some more info on Apache Hadoop :
http://hadoop.apache.org/


### Goals ###

This doscker images has been designed to be a test, development, integration, production environment for Apache Hadoop single node and cluster instances.
*No warranties for production use.*



### Docker Image features ###

Here some information :

Volumes : /user/root/data/hadoop/hdfs/datanode, /user/root/data/hadoop/hdfs/namenode, /user/root/data/hadoop/hdfs/checkpoint

`/user/root/data/hadoop/hdfs/datanode` :
DataNode storage folder.

`/user/root/data/hadoop/hdfs/namenode` :
NameNode storage folder.

`/user/root/data/hadoop/hdfs/checkpoint`:
Check Point and Check Point Edits storage folder.


Ports:

HDFS ports :

50010 50020 50070 50075 50090 8020 9000


MAP Reduce ports :

10020 19888


YARN ports:

8030 8031 8032 8033 8040 8042 8088


Other Apache Hadoop ports:
49707 2122


### Docker Environment Variable ###

Here Apache Hadoop single mode container environment variables :

* `MACHINE_TIMEZONE` : Set Machine timezone ([See Timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))
* `APACHE_HADOOP_SITE_BUFFER_SIZE` : Set Hadoop Buffer Size (default: 131072)
* `APACHE_HADOOP_SITE_HOSTNAME`: Set Hadoop master site hostname, as default `localhost` will be replaced with machine hostname


Here Apache Hadoop cluster mode container environment variables :

* `MACHINE_TIMEZONE` : Set Machine timezone ([See Timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))
* `APACHE_HADOOP_IS_CLUSTER` : Set cluster mode (yes/no)
* `APACHE_HADOOP_IS_MASTER` : Does this node is assumed as cluter master node? (yes/no)
* `APACHE_HADOOP_SITE_BUFFER_SIZE` : Set Hadoop Buffer Size (default: 131072)
* `APACHE_HADOOP_SITE_HOSTNAME`: Set Hadoop master site hostname, as default `localhost` will be replaced with machine hostname



### Sample command ###

Here a sample command to run Apache Hadoop container:

```bash
docker run -d -p 49707:49707 -p 2122:2122 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 \
       -p 8088:8088 -p 10020:10020 -p 19888:19888  -p 50010:50010  -p 50020:50020  -p 50070:50070  -p 50075:50075  -p 50090:50090 \
        -p 8020:8020  -p 9000:9000 -v my/datanode/dir:/user/root/data/hadoop/hdfs/datanode -v my/namenode/dir:/user/root/data/hadoop/hdfs/namenode \
         -v my/checkpoint/dir:/user/root/data/hadoop/hdfs/checkpoint --name my-apache-hadoop hellgate75/apache-hadoop:latest
```


### License ###

[LGPL 3](/LICENSE)
