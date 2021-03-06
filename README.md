# Apache Hadoop Docker image


Docker Image for Apache Hadoop Single/Cluster Node


Provided Apache Hadoop docker images:
* [Apache™ Hadoop® 2.6.5](https://github.com/hellgate75/apache-hadoop/tree/2.6.5)
* [Apache™ Hadoop® 2.7.3](https://github.com/hellgate75/apache-hadoop/tree/2.7.3)
* [Apache™ Hadoop® 2.8.0](https://github.com/hellgate75/apache-hadoop/tree/2.8.0)
* [Apache™ Hadoop® 3.0.0-alpha3](https://github.com/hellgate75/apache-hadoop/tree/3.0.0-alpha3)
* [Apache™ Hadoop® latest](https://github.com/hellgate75/apache-hadoop) (Apache™ Hadoop® 3.0.0-alpha3)


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

Volumes : /user/root/data/hadoop/hdfs/datanode, /user/root/data/hadoop/hdfs/namenode, /user/root/data/hadoop/hdfs/checkpoint, /etc/config/hadoop

`/user/root/data/hadoop/hdfs/datanode` :

DataNode storage folder.

`/user/root/data/hadoop/hdfs/namenode` :

NameNode storage folder.

`/user/root/data/hadoop/hdfs/checkpoint`:

Check Point and Check Point Edits storage folder.

`/etc/config/hadoop`:

Configuration folder, and expected/suitable files are :

* `core-site.xml`: Core Site custmized configuration file
* `yarn-site.xml`: Yarn Site custmized configuration file
* `hdfs-site.xml`: HDFS Site custmized configuration file
* `mapred-site.xml`: Map Reduce Site custmized configuration file


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
* `HADOOP_CONFIG_TGZ_URL` : Url of a tar gz file within Apache™ Hadoop® configuration files. If this archive contains a shell script named `bootstrap.sh`, it will be executed before to start Apache™ Hadoop® (default: "")
* `APACHE_HADOOP_SITE_BUFFER_SIZE` : Set Hadoop Buffer Size (default: 131072)
* `APACHE_HADOOP_SITE_HOSTNAME`: Set Hadoop master site hostname, as default `localhost` will be replaced with machine hostname

For more information about values : [Apache Hadoop Single Node](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/SingleCluster.html)


Here Apache Hadoop cluster mode container environment variables :

* `MACHINE_TIMEZONE` : Set Machine timezone ([See Timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))
* `HADOOP_CONFIG_TGZ_URL` : Url of a tar gz file within Apache™ Hadoop® configuration files. If this archive contains a shell script named `bootstrap.sh`, it will be executed before to start Apache™ Hadoop® (default: "")
* `APACHE_HADOOP_IS_CLUSTER` : Set cluster mode (yes/no)
* `APACHE_HADOOP_IS_MASTER` : Does this node lead cluster workers as the cluter master node? (yes/no)
* `APACHE_HADOOP_SITE_BUFFER_SIZE` : Set Hadoop Buffer Size (default: 131072)
* `APACHE_HADOOP_SITE_HOSTNAME`: Set Hadoop master site hostname, as default `localhost` will be replaced with machine hostname
* `APACHE_HADOOP_HDFS_REPLICATION`: Set HDFS Replication factor  (default: 1)
* `APACHE_HADOOP_HDFS_BLOCKSIZE`: Set HDFS Block Size (default: 268435456)
* `APACHE_HADOOP_HDFS_HANDLERCOUNT`: Set HDFS Header Count (default: 100)
* `APACHE_HADOOP_YARN_RESOURCE_MANAGER_HOSTNAME`: Set Yarn Resource Manager hostname, as default `localhost` will be replaced with machine hostname
* `APACHE_HADOOP_YARN_ACL_ENABLED`: Set Yarn ACL Enabled (default: false values: true|false)
* `APACHE_HADOOP_YARN_ADMIN_ACL`: Set Admin ACL Name (default: `*`)
* `APACHE_HADOOP_YARN_AGGREGATION_RETAIN_SECONDS`: Set Yarn Log aggregation retain time in seconds (default: 60)
* `APACHE_HADOOP_YARN_AGGREGATION_RETAIN_CHECK_SECONDS`: Set Yarn Log aggregation retain chack time in seconds (default: 120)
* `APACHE_HADOOP_YARN_LOG_AGGREGATION`: Set Yarn Log Aggregation enabled (default: false values: true|false)
* `APACHE_HADOOP_MAPRED_JOB_HISTORY_HOSTNAME`: Set Job History Server Address/Hostname, as default `localhost` will be replaced with machine hostname
* `APACHE_HADOOP_MAPRED_JOB_HISTORY_PORT`: Set Job History Server Port (default: 10020)
* `APACHE_HADOOP_MAPRED_JOB_HISTORY_WEBUI_HOSTNAME`: Set Job History Web UI Server Address/Hostname, as default `localhost` will be replaced with machine hostname
* `APACHE_HADOOP_MAPRED_JOB_HISTORY_WEBUI_PORT`:Set Job History Web UI Server Port (default: 19888)
* `APACHE_HADOOP_MAPRED_MAP_MEMORY_MBS`: Set Map Reduce Map allocated Memory in MBs (default: 1536)
* `APACHE_HADOOP_MAPRED_MAP_JAVA_OPTS`: Set Map Reduce Map Java options  (default: `-Xmx1024M`)
* `APACHE_HADOOP_MAPRED_RED_MEMORY_MBS`: Set Map Reduce Reduce allocated Memory in MBs (default: 3072)
* `APACHE_HADOOP_MAPRED_RED_JAVA_OPTS`: Set Map Reduce Reduce Java options (default: `-Xmx2560M`)
* `APACHE_HADOOP_MAPRED_SORT_MEMORY_MBS`: Set Map Reduce Sort allocated Memory in MBs (default: 512)
* `APACHE_HADOOP_MAPRED_SORT_FACTOR`: Set Map Reduce Sort factor (default: 100)
* `APACHE_HADOOP_MAPRED_SHUFFLE_PARALLELCOPIES`: Set Map Reduce Shuffle parallel copies limit (default: 50)

For more information about values : [Apache Hadoop Cluster Setup](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html)


### Sample command ###

Here a sample command to run Apache Hadoop container:

```bash
docker run -d -p 49707:49707 -p 2122:2122 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 \
       -p 8088:8088 -p 10020:10020 -p 19888:19888  -p 50010:50010  -p 50020:50020  -p 50070:50070  -p 50075:50075  -p 50090:50090 \
        -p 8020:8020  -p 9000:9000 -v my/datanode/dir:/user/root/data/hadoop/hdfs/datanode -v my/namenode/dir:/user/root/data/hadoop/hdfs/namenode \
         -v my/checkpoint/dir:/user/root/data/hadoop/hdfs/checkpoint --name my-apache-hadoop hellgate75/apache-hadoop:latest
```


### Test YARN console ###

In order to access to yarn console you can use a web browser and type :
```bash
    http://{hostname or ip address}:8088
    eg.:
    http://localhost:8088 for a local container
```


### License ###

[LGPL 3](/LICENSE)
