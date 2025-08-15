#!/bin/bash

kubectl apply -f logging-namespace.yml
kubectl apply -f logstash-secret.yml
kubectl apply -f logstash-configmap.yml
kubectl apply -f logstash.yml
kubectl apply -f logstash-service.yml

kubectl apply -f filebeat-authorization.yml
kubectl apply -f filebeat-configmap.yml
kubectl apply -f filebeat-daemonset.yml
kubectl apply -f kubernetes-event-exporter.yml
