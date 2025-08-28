#!/bin/bash

kubectl delete -f filebeat-daemonset.yml
kubectl delete -f filebeat-configmap.yml
kubectl delete -f filebeat-authorization.yml
kubectl delete -f kubernetes-event-exporter.yml

kubectl delete -f logstash-service.yml
kubectl delete -f logstash.yml
kubectl delete -f logstash-configmap.yml
kubectl delete -f logstash-secret.yml

kubectl delete -f logging-namespace.yml
