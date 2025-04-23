# K8S - Lab

Create the cassandra-lab
```bash
# INFO: Execute commands from the root project.
# Create ns
kubectl create namespace cassandra-lab
# Create objects
kubectl apply -f ./k8s/cassandra-service.yml
# Create PV, replace for your absolute path
kubectl apply -f ./k8s/jmx-exporter-pv.yml
############
kubectl apply -f ./k8s/jmx-exporter-pvc.yml
kubectl apply -f ./k8s/prometheus-service.yml
kubectl apply -f ./k8s/prometheus-configmap.yml
kubectl apply -f ./k8s/cassandra-stfset.yml
kubectl apply -f ./k8s/prometheus-deploy.yml
kubectl apply -f ./k8s/grafana-service.yml
kubectl apply -f ./k8s/grafana-deploy.yml
```

Utils commands:
```bash
# Check tokens owns effective
kubectl exec -it cassandra-0 -n cassandra-lab -- nodetool status

# Check Thread pool stats
kubectl exec -it cassandra-0 -n cassandra-lab -- nodetool tpstats

# Check Column Family stats
kubectl exec -it cassandra-0 -n cassandra-lab -- nodetool cfstats



# Rollout satefulset
kubectl rollout restart statefulset cassandra -n cassandra-lab
# Force delete pod
kubectl delete pod cassandra-0 -n cassandra-lab --grace-period=0 --force
```

# PromQL

List util metrics:

[Docs metrics](https://cassandra.apache.org/doc/stable/cassandra/operating/metrics.html)

## State nodes on ring
org_apache_cassandra_db_StorageService_Drained
org_apache_cassandra_db_StorageService_Draining
org_apache_cassandra_db_StorageService_Joined --> ok
org_apache_cassandra_db_StorageService_Starting

## Resrouces used
java_lang_Memory_HeapMemoryUsage_used
java_lang_Memory_NonHeapMemoryUsage_used

java_lang_OperatingSystem_SystemCpuLoad

CPU

## Disk space
org_apache_cassandra_metrics_Table_Value{name="TotalDiskSpaceUsed"}

## Writes and reads
org_apache_cassandra_metrics_Table_StdDev{name="ReadLatency"}

## Compaction
- Process that merge SSTable files to delete duplicate data or old data.

org_apache_cassandra_metrics_Compaction_Value{name="PendingTasks"}
org_apache_cassandra_metrics_Compaction_Count{name="BytesCompacted"}

## Hints and reparations
- The hints is a pending write, is a note.
org_apache_cassandra_metrics_Storage_Count{name="TotalHints"}
org_apache_cassandra_metrics_Storage_Count{name="TotalHintsInProgress"}

- The reparations are the synchronization process of nodes. The next metrics shows total of bytes that should be repair.
org_apache_cassandra_metrics_Table_Value{name="BytesUnrepaired"}

## messages
org_apache_cassandra_metrics_Messaging_StdDev{name="datacenter1-Latency"}

sum(org_apache_cassandra_metrics_DroppedMessage_MeanRate{name="Dropped", instance="cassandra-0.cassandra.cassandra-lab.svc.cluster.local:7200"})

org_apache_cassandra_net_MessagingService_TotalTimeouts

## ThreadPools
- Multiple tasks by pool or by type tasks

org_apache_cassandra_metrics_ThreadPools_Value{name="ActiveTasks"}
org_apache_cassandra_metrics_ThreadPools_Value{name="PendingTasks"}


### Grafana dashboards
Acces into grafana container:
  - localhost:30000
Import k8s/grfn-dashboard-cassandra.json dashboard

## JMX Explorer data

All data is inside on JMX, but not all metrics will be scrape by default. See how to surfing among all data and find specific metrics

```bash
# Enter into jdk enviorentment, the jmx-exporter
kubectl exec -it cassandra-0 -n cassandra-lab -c jmx-export -- /bin/bash

# Download the jmxterm
# https://docs.cyclopsgroup.org/jmxterm
wget https://github.com/jiaqi/jmxterm/releases/download/v1.0.4/jmxterm-1.0.4-uber.jar

# Execute and surfing inside into Jmx terminal:
java -jar jmxterm-1.0.2-uber.jar

# Connect a jmx remote
open cassandra-0.cassandra.cassandra-lab.svc.cluster.local:7199

# List domains
domain

# Select domain
domain org.apache.cassandra.db

# List MBeans
beans

# List atributes of StorageService
bean org.apache.cassandra.db:type=StorageService
info

# get total tokens by node, get atribute
get Tokens
```
# Docker / Podman - Lab

Create the cassandra-lab
```bash
podman-compose up -d
```
