# K8S

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
# Forzar eliminación de pod en estado terminating
kubectl delete pod <pod-name> --grace-period=0 --force
```
# Docker / Podman

Create the cassandra-lab
```bash
podman-compose up -d
```
# PromQL

- % DB loads by node

```GO
(
  sum(org_apache_cassandra_metrics_Storage_Count{
    name=~"Load",instance="cassandra-0.cassandra.cassandra-lab.svc.cluster.local:7200"
    }
  )
  /
  sum(
    org_apache_cassandra_metrics_Storage_Count{
      name=~"Load"
    }
  )
) * 100
```

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

