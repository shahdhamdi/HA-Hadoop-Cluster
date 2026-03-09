# Hadoop High Availability Cluster 

A fully containerized **Hadoop High Availability cluster** built using **Docker, Apache Hadoop, HDFS, YARN, and ZooKeeper**.

This project simulates a **distributed Hadoop environment** locally where each container represents a node in a real cluster.

The cluster demonstrates:

- HDFS High Availability
- YARN resource management
- ZooKeeper failover coordination
- Distributed storage using HDFS
- Multi-node cluster orchestration

---

# Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Cluster Nodes](#cluster-nodes)
- [Service Breakdown](#service-breakdown)
- [Cluster Boot Sequence](#cluster-boot-sequence)
- [Setup Instructions](#setup-instructions)
- [Cluster Verification](#cluster-verification)
- [Web Interfaces](#web-interfaces)
- [Failover Test](#failover-test)
- [Conclusion](#conclusion)

---

# Project Overview

This project provisions a **5-node Hadoop High Availability cluster** using Docker containers.

Each container simulates a physical server in a distributed Hadoop deployment.

The cluster includes:

- Active NameNode
- Standby NameNode
- JournalNode quorum
- ZooKeeper coordination
- YARN ResourceManager
- Worker nodes running DataNode and NodeManager

This architecture ensures **fault tolerance**, allowing the system to continue running even if a master node fails.

---

# Architecture

<img width="1150" height="627" alt="Image" src="https://github.com/user-attachments/assets/24852089-e627-41cd-9664-1b000e7c3708" />

---

# Technology Stack

| Component | Version | Purpose |
|--------|--------|--------|
| Docker | 20+ | Container runtime |
| Docker Compose | v3.9 | Cluster orchestration |
| Ubuntu | 24.04 | Base OS |
| Apache Hadoop | 3.4.2 | Distributed computing framework |
| HDFS | 3.4.2 | Distributed filesystem |
| YARN | 3.4.2 | Resource manager |
| ZooKeeper | 3.8.6 | Distributed coordination |
| OpenJDK | 11 | Java runtime |

---

# Cluster Nodes

## node01 — Active Master

Services:

- NameNode (Active)
- ResourceManager
- JournalNode
- ZooKeeper

Responsibilities:

- Handles filesystem operations
- Manages cluster resources
- Coordinates failover services



## node02 — Standby Master

Services:

- NameNode (Standby)
- ResourceManager (Standby)
- JournalNode
- ZooKeeper

Responsibilities:

- Syncs metadata with Active NameNode
- Takes over in case of failure


## node03 — Coordination + Worker

Services:

- DataNode
- NodeManager
- JournalNode
- ZooKeeper

Responsibilities:

- Completes JournalNode quorum
- Executes YARN containers
- Stores HDFS blocks

---

## node04 — Worker Node

Services:

- DataNode
- NodeManager

Responsibilities:

- Stores HDFS data blocks
- Executes distributed tasks

---

## node05 — Worker Node

Services:

- DataNode
- NodeManager

Responsibilities:

- Provides additional storage
- Provides compute resources

---

# Service Breakdown

## NameNode

Maintains the entire HDFS namespace and metadata.

Configuration example:

```bash
dfs.namenode.name.dir=/opt/hadoop/data/namenode
```
---

## DataNode

Stores the actual HDFS blocks.

Configuration:

```bash
dfs.datanode.data.dir=/opt/hadoop/data/datanode
```

---

## JournalNode

Stores replicated edit logs required for NameNode synchronization.

---

## ZooKeeper

Provides distributed coordination including:

- leader election
- failover coordination
- cluster state management

---

## ResourceManager

Responsible for:

- job scheduling
- cluster resource allocation
- monitoring running applications


---

## NodeManager

Runs on worker nodes and manages container execution.

Responsibilities:

- launching containers
- monitoring resources
- reporting status to ResourceManager

---

# Cluster Boot Sequence

Cluster services start in the following order:

1. ZooKeeper
2. JournalNodes
3. Active NameNode
4. Standby NameNode bootstrap
5. ResourceManagers
6. DataNodes
7. NodeManagers

---

# Setup Instructions

## Clone repository

```bash
git clone https://github.com/shahdhamdi/HA-Hadoop-Cluster.git
cd hadoop-ha-cluster
```

## Build docker images

```bash
docker compose build
```

## Start cluster

```bash
docker compose up -d
```

## Check running containers

```bash
docker ps
```

---

# Cluster Verification

Check running services:

```bash
docker exec -it --user root node01 jps
```

Check NameNode states:

```bash
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2
```

Check HDFS cluster status:

```bash
hdfs dfsadmin -report
```

---

# Web Interfaces

| Service | URL |
|------|------|
| Active NameNode | http://localhost:9871 |
| Standby NameNode | http://localhost:9872 |
| ResourceManager | http://localhost:8081 |
| ResourceManager Standby | http://localhost:8082 |
| NodeManager node03 | http://localhost:8083 |
| NodeManager node04 | http://localhost:8084 |
| NodeManager node05 | http://localhost:8085 |

---

# Failover Test

Simulate NameNode failure.

Stop the active NameNode:

```bash
docker exec node01 pkill -f NameNode
```

Check the state:

```bash
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2
```

The standby node should become **Active** automatically.

---

# Conclusion

This project demonstrates a **fully functional Hadoop High Availability cluster** using containerized infrastructure.

Key concepts implemented:

- Active / Standby NameNode architecture
- JournalNode quorum for edit log replication
- ZooKeeper coordination for automatic failover
- Distributed storage using HDFS
- Distributed processing using YARN

