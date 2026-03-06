#!/bin/bash

set -o pipefail -e
export PRELAUNCH_OUT="/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/prelaunch.out"
exec >"${PRELAUNCH_OUT}"
export PRELAUNCH_ERR="/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/prelaunch.err"
exec 2>"${PRELAUNCH_ERR}"
echo "Setting up env variables"
export JAVA_HOME=${JAVA_HOME:-"/usr/lib/jvm/java-11-openjdk-amd64"}
export HADOOP_COMMON_HOME=${HADOOP_COMMON_HOME:-"/opt/hadoop"}
export HADOOP_HDFS_HOME=${HADOOP_HDFS_HOME:-"/opt/hadoop"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/opt/hadoop/etc/hadoop"}
export HADOOP_YARN_HOME=${HADOOP_YARN_HOME:-"/opt/hadoop"}
export HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}
export PATH=${PATH:-"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/hadoop/bin:/opt/hadoop/sbin"}
export HADOOP_TOKEN_FILE_LOCATION="/shared/nm-local/usercache/root/appcache/application_1772824885986_0001/container_1772824885986_0001_01_000003/container_tokens"
export CONTAINER_ID="container_1772824885986_0001_01_000003"
export NM_PORT="37091"
export NM_HOST="node04"
export NM_HTTP_PORT="8042"
export LOCAL_DIRS="/shared/nm-local/usercache/root/appcache/application_1772824885986_0001"
export LOCAL_USER_DIRS="/shared/nm-local/usercache/root/"
export LOG_DIRS="/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003"
export USER="root"
export LOGNAME="root"
export HOME="/home/"
export PWD="/shared/nm-local/usercache/root/appcache/application_1772824885986_0001/container_1772824885986_0001_01_000003"
export LOCALIZATION_COUNTERS="0,522955,0,2,7"
export JVM_PID="$$"
export NM_AUX_SERVICE_mapreduce_shuffle="AAA0+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
export STDOUT_LOGFILE_ENV="/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/stdout"
export SHELL="/bin/bash"
export HADOOP_ROOT_LOGGER="INFO,console"
export HADOOP_MAPRED_HOME="/opt/hadoop"
export CLASSPATH="$PWD:$HADOOP_CONF_DIR:$HADOOP_COMMON_HOME/share/hadoop/common/*:$HADOOP_COMMON_HOME/share/hadoop/common/lib/*:$HADOOP_HDFS_HOME/share/hadoop/hdfs/*:$HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/*:$HADOOP_YARN_HOME/share/hadoop/yarn/*:$HADOOP_YARN_HOME/share/hadoop/yarn/lib/*:$HADOOP_CONF_DIR:$HADOOP_COMMON_HOME/share/hadoop/common/*:$HADOOP_COMMON_HOME/share/hadoop/common/lib/*:$HADOOP_HDFS_HOME/share/hadoop/hdfs/*:$HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/*:$HADOOP_YARN_HOME/share/hadoop/yarn/*:$HADOOP_YARN_HOME/share/hadoop/yarn/lib/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib-examples/*:job.jar/*:job.jar/classes/:job.jar/lib/*:$PWD/*"
export LD_LIBRARY_PATH="$PWD:$HADOOP_COMMON_HOME/lib/native"
export STDERR_LOGFILE_ENV="/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/stderr"
export HADOOP_CLIENT_OPTS=""
export MALLOC_ARENA_MAX="4"
echo "Setting up job resources"
ln -sf -- "/shared/nm-local/usercache/root/appcache/application_1772824885986_0001/filecache/15/job.xml" "job.xml"
ln -sf -- "/shared/nm-local/usercache/root/appcache/application_1772824885986_0001/filecache/14/job.jar" "job.jar"
echo "Copying debugging information"
# Creating copy of launch script
cp "launch_container.sh" "/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/launch_container.sh"
chmod 640 "/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/launch_container.sh"
# Determining directory contents
echo "ls -l:" 1>"/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/directory.info"
ls -l 1>>"/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/directory.info"
echo "find -L . -maxdepth 5 -ls:" 1>>"/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/directory.info"
find -L . -maxdepth 5 -ls 1>>"/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/directory.info"
echo "broken symlinks(find -L . -maxdepth 5 -type l -ls):" 1>>"/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/directory.info"
find -L . -maxdepth 5 -type l -ls 1>>"/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/directory.info"
echo "Launching container"
exec /bin/bash -c "$JAVA_HOME/bin/java -Djava.net.preferIPv4Stack=true -Dhadoop.metrics.log.level=WARN   -Xmx820m -Djava.io.tmpdir=$PWD/tmp -Dlog4j.configuration=container-log4j.properties -Dyarn.app.container.log.dir=/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003 -Dyarn.app.container.log.filesize=0 -Dhadoop.root.logger=INFO,CLA -Dhadoop.root.logfile=syslog -Dyarn.app.mapreduce.shuffle.logger=INFO,shuffleCLA -Dyarn.app.mapreduce.shuffle.logfile=syslog.shuffle -Dyarn.app.mapreduce.shuffle.log.filesize=0 -Dyarn.app.mapreduce.shuffle.log.backups=0 org.apache.hadoop.mapred.YarnChild 172.18.0.6 46181 attempt_1772824885986_0001_r_000000_0 3 1>/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/stdout 2>/shared/nm-logs/application_1772824885986_0001/container_1772824885986_0001_01_000003/stderr "
