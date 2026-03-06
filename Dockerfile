# ---------------- BASE IMAGE ----------------
FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# ---------------- DEPENDENCIES ----------------
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    openssh-server \
    openssh-client \
    wget vim curl net-tools netcat-openbsd \
    pdsh sudo \
    && rm -rf /var/lib/apt/lists/*

# ---------------- ENVIRONMENT ----------------
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV ZOOKEEPER_CONF_DIR=$ZOOKEEPER_HOME/conf
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$ZOOKEEPER_HOME/bin

# ---------------- DOWNLOAD TARBALLS ----------------
# ---------------- DOWNLOAD TARBALLS ----------------
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz -O /tmp/hadoop-3.3.6.tar.gz && \
    wget https://downloads.apache.org/zookeeper/zookeeper-3.8.6/apache-zookeeper-3.8.6-bin.tar.gz -O /tmp/apache-zookeeper-3.8.6-bin.tar.gz

# ---------------- EXTRACT ----------------
RUN tar -xzf /tmp/hadoop-3.3.6.tar.gz -C /opt/ && \
    mv /opt/hadoop-3.3.6 /opt/hadoop && \
    tar -xzf /tmp/apache-zookeeper-3.8.6-bin.tar.gz -C /opt/ && \
    mv /opt/apache-zookeeper-3.8.6-bin /opt/zookeeper && \
    rm /tmp/*.tar.gz

# ---------------- SSH SETUP ----------------
# RUN mkdir -p /root/.ssh && \
#     ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa && \
#     cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
#     chmod 600 /root/.ssh/authorized_keys && \
#     echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
#     echo "StrictHostKeyChecking no" >> /root/.ssh/config

# ---------------- COPY CONFIGS ----------------
COPY shared/config/hadoop/core-site.xml      $HADOOP_CONF_DIR/
COPY shared/config/hadoop/hdfs-site.xml      $HADOOP_CONF_DIR/
COPY shared/config/hadoop/yarn-site.xml      $HADOOP_CONF_DIR/
COPY shared/config/hadoop/mapred-site.xml    $HADOOP_CONF_DIR/
COPY shared/config/hadoop/hadoop-env.sh      $HADOOP_CONF_DIR/
COPY shared/config/zookeeper/zoo.cfg         $ZOOKEEPER_CONF_DIR/

# ---------------- COPY START SCRIPT ----------------
COPY Scripts/start-all.sh /start-all.sh
RUN chmod +x /start-all.sh

# ---------------- ENTRYPOINT ----------------
# Automatically starts SSH, Hadoop, ZooKeeper, and YARN services
ENTRYPOINT ["/start-all.sh"]