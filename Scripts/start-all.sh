#!/bin/bash

echo "Starting Hadoop HA services on $(hostname)..."

ZOOKEEPER_DATA=/opt/zookeeper/data
NN_DIR=/opt/hadoop/data/namenode

echo "Waiting for Docker DNS..."

for host in node01 node02 node03; do
  until getent hosts $host; do
    echo "Waiting for $host DNS..."
    sleep 2
  done
done

mkdir -p $ZOOKEEPER_DATA

case "$NODE_ROLE" in
  node01) echo "1" > $ZOOKEEPER_DATA/myid ;;
  node02) echo "2" > $ZOOKEEPER_DATA/myid ;;
  node03) echo "3" > $ZOOKEEPER_DATA/myid ;;
esac

if [[ "$NODE_ROLE" =~ node0[1-3] ]]; then
    echo "Starting ZooKeeper..."
    /opt/zookeeper/bin/zkServer.sh start
fi

sleep 6

if [[ "$NODE_ROLE" =~ node0[1-3] ]]; then
    echo "Starting JournalNode..."
    hdfs --daemon start journalnode
fi


if [[ "$NODE_ROLE" == "node01" || "$NODE_ROLE" == "node02" ]]; then

echo "Waiting for JournalNodes..."

for host in node01 node02 node03; do
  until nc -z $host 8485; do
    echo "Waiting for $host:8485..."
    sleep 2
  done
done

echo "JournalNodes ready."

fi

if [[ "$NODE_ROLE" == "node01" ]]; then

if [ ! -d "$NN_DIR/current" ]; then
  echo "Formatting NameNode..."
  hdfs namenode -format -force -nonInteractive
fi

hdfs --daemon start namenode
sleep 8

echo "Formatting ZooKeeper HA..."

hdfs zkfc -formatZK -force || true

hdfs --daemon start zkfc

fi

if [[ "$NODE_ROLE" == "node02" ]]; then

echo "Waiting for Active NameNode..."

until nc -z node01 8020; do
  sleep 3
done

if [ ! -d "$NN_DIR/current" ]; then
  echo "Bootstrapping Standby..."
  hdfs namenode -bootstrapStandby -force
fi

hdfs --daemon start namenode
sleep 5
hdfs --daemon start zkfc

fi

sleep 5

if [[ "$NODE_ROLE" =~ node0[3-5] ]]; then
  echo "Starting DataNode..."
  hdfs --daemon start datanode
fi

sleep 5


if [[ "$NODE_ROLE" =~ node0[1-2] ]]; then
  echo "Starting ResourceManager..."
  yarn --daemon start resourcemanager
fi

if [[ "$NODE_ROLE" =~ node0[3-5] ]]; then
  echo "Starting NodeManager..."
  yarn --daemon start nodemanager
fi

echo "All services started on $NODE_ROLE."

tail -f /dev/null
