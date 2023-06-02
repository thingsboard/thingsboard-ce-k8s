
# Kafka manager with web UI to monitor and maintain Kafka's clusters

## General Information
The container on: [Docker Redpanda Console](https://hub.docker.com/r/redpandadata/console)

You can find the documentation of the service here: [Redpanda Console repository](https://github.com/redpanda-data/console)

## Deployment
The service requests at least 50 mCPU and 500 megabytes of RAM.

By default, our Redpanda Console deployment is configured to use Kubernetes **tb-kafka** service as a connection endpoint to Kafka. If you use an external broker, please override the `KAFKA_BROKERS` variable to list your kafka brokers, a.g.:

```
            - name: KAFKA_BROKERS
              value: "kafka-broker1:9092,kafka-broker2:9092,kafka-broker3:9092"
```
Apply the deployment file:
```shell
kubectl apply -f tb-kafka-ui.yml
```

## Connect to UI:

We didn't add external access to this tool because it is a system tool. So use port forwarding to the local machine to access the service:
```shell
kubectl port-forward sts/tb-node 8085:8080
```

goto weblink: http://localhost:8085

