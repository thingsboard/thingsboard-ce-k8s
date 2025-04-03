### Logging on ELK stack (Elasticsearch, Logstash, Kibana)

The agent that scrapes raw logs is a *filebeat* by Elastic. It runs on each node and set as a *daemonset*.

All filebeat agents are generally watching and tailing log files and pack each log as message to logstash with some metadata.
The most valuable function configured for ThingsBoard stack is a multiline template that recognizes multiline logs as a single message.
As a result you will get a Java stacktrace or json payload as a single message on the Kibana UI!

The *logstash* service are responsible for gathering logs from filebeats, *converting* logs from raw string to *structured columns* and sending to the ElasticSearch by https using *batching* and *compression*

**Before you install** logging please fill the `logstash-secret.yml` with your endpoint, user and password to supply data
Please avoid storing an unencrypted secrets in VCS (git) repo.

Make sure you stick logstash to monitoring like nodegroup or some affinity rules added

```bash
cd logging
./install-logging.sh
```

Note: ElasticSearch does not have a data retention policy enabled by default. It will consume data until run out of disk space. Kindly recommended to setup a data retention policy (log rotation)

# Useful commands

```bash
kubectl get ds -A
kubectl get pods -n logging
kubectl logs -f --tail 99 logstash-0 -n logging
```
