
# Kafka manager with web UI to monitor and maintain Kafka's clusters

## General Information
The container on: [Docker Redpanda Console](https://hub.docker.com/r/redpandadata/console)

You can find the documentation of the service here: [Redpanda Console repository](https://github.com/redpanda-data/console)

## Deployment
By default, the service has 50 mCPU and 100 megabytes of RAM requested resources. This is enough for the normal operation of the service. But this value can be overridden individually for each deployment.

By default, our Redpanda Console deployment is configured to use Kubernetes **tb-kafka** service as a connection endpoint to Kafka. If you use an external broker, please override the `KAFKA_BROKERS` variable to list your kafka brokers, a.g.:

```shell
            - name: KAFKA_BROKERS
              value: "kafka-broker1:9092,kafka-broker2:9092,kafka-broker3:9092"
```

### Configuring access to Kafka via SASL

Uncomment the variables in the tb-kafka-ui.yml deployment file to use SASL.

For the username and password, the best practice is to use Kubernetes Secrets. Please specify them *(Be sure to change **YOUR_USERNAME** and **YOUR_PASSWORD**)*:
```shell
export SASL_USERNAME=YOUR_USERNAME
export SASL_PASSWORD=YOUR_PASSWORD

kubectl create -n thingsboard secret generic kafka-sasl-credentials \
--from-literal=kafka-sasl-username=$SASL_USERNAME \
--from-literal=kafka-sasl-password=$SASL_PASSWORD
```

Apply the deployment file:
```shell
kubectl apply -f tb-kafka-ui.yml
```

## Connect to UI

We didn't add external access to this tool because it is a system tool. So use port forwarding to the local machine to access the service:
```shell
kubectl port-forward sts/kafka-ui-redpanda 8085:8080
```

goto weblink: http://localhost:8085


If Kafka UI does not need, scale it down:
```shell
kubectl scale --replicas=0 statefulset kafka-ui-redpanda
```