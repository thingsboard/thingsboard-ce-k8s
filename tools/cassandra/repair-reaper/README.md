# Cassandra reaper - automated repair for Cassandra 

http://cassandra-reaper.io/

# Setup
```cql
CREATE KEYSPACE IF NOT EXISTS reaper_db WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenter1': 3 };
CREATE KEYSPACE reaper_db WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'};
ALTER KEYSPACE reaper_db WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'};
```

# Web UI

```bash
kubectl port-forward svc/cassandra-reaper 8080
```

http://localhost:8080/webui/


# Fixing IP seeds on the cluster settings

```cql
use reaper_db;
select * from cluster;
UPDATE reaper_db.cluster SET seed_hosts = {'cassandra-helm-headless'} WHERE name = 'thingsboard_cluster';
```
