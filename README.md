# Distributed Hadoop HA Cluster (Docker Based)

This project implements a **multi-node Hadoop cluster with High Availability** using Docker containers.  
Each container represents an independent node inside a simulated distributed environment.

The cluster is designed to demonstrate:

- HDFS distributed storage
- High Availability for NameNode
- ZooKeeper based failover
- Resource management using YARN
- Multi-node worker execution

The goal is to recreate the behavior of a **Hadoop cluster architecture** on a local machine.

---

# What This Project Builds

The environment launches **five separate nodes** connected through a shared Docker network.

These nodes collaborate to provide:

- fault tolerant HDFS storage
- distributed processing
- cluster coordination
- automatic master failover

The system ensures that if the **primary NameNode stops**, the **standby node automatically becomes active**.

---

# Cluster Architecture
<img width="1150" height="627" alt="Image" src="https://github.com/user-attachments/assets/24852089-e627-41cd-9664-1b000e7c3708" />

---
# Architecture Explaination

## Master1

Main services running on this node:

- Active NameNode
- ResourceManager
- JournalNode
- ZooKeeper

Responsibilities:

- managing HDFS metadata
- handling filesystem requests
- scheduling distributed jobs

---

## Master2

Runs as the **backup master node**.

Services:

- Standby NameNode
- Standby ResourceManager
- JournalNode
- ZooKeeper

Responsibilities:

- continuously synchronizing filesystem metadata
- taking control if the primary NameNode fails

---

## Worker1

Mixed role node.

Services:

- DataNode
- NodeManager
- JournalNode
- ZooKeeper

Responsibilities:

- storing HDFS data blocks
- executing YARN containers
- participating in quorum services

---

## Worker2

Worker node focused on computation and storage.

Services:

- DataNode
- NodeManager

Responsibilities:

- storing distributed data
- running processing tasks

---

## Worker3

Additional worker node that expands cluster capacity.

Services:

- DataNode
- NodeManager

Responsibilities:

- additional storage
- additional compute resources

---

# Tools and Technologies

| Tool | Purpose |
|-----|------|
| Docker | Container runtime |
| Docker Compose | Multi-container orchestration |
| Ubuntu | Base container OS |
| Apache Hadoop | Distributed data platform |
| HDFS | Distributed file system |
| YARN | Resource scheduling system |
| ZooKeeper | Cluster coordination |
| OpenJDK | Java runtime |

---
# Starting the Cluster

## Clone the project

```bash
git clone https://github.com/shahdhamdi/HA-Hadoop-Cluster.git
cd hadoop-ha-cluster
```

## Build containers

```bash
docker compose build
```

## Launch the cluster

```bash
docker compose up -d
```

## Verify containers are running

```bash
docker ps
```

---

# Basic Cluster Checks

Check running Hadoop processes:

```bash
docker exec -it node01 jps
```

Verify NameNode state:

```bash
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2
```


# Web Dashboards

These interfaces allow monitoring cluster components.

| Component | Address |
|------|------|
| NameNode (Active) | http://localhost:9871 |
| NameNode (Standby) | http://localhost:9872 |
| ResourceManager | http://localhost:8081 |
| Worker NodeManager | http://localhost:8083 |
| Worker NodeManager | http://localhost:8084 |
| Worker NodeManager | http://localhost:8085 |

---


# Final Notes

This project demonstrates how distributed systems like Hadoop achieve **fault tolerance and scalability**.

Key features implemented:

- Active / Standby NameNode architecture
- JournalNode quorum synchronization
- ZooKeeper driven failover
- distributed storage using HDFS
- distributed job execution with YARN

