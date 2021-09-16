# Kubernetes resources configuration for ThingsBoard Microservices

This repository contains scripts for deploying ThingsBoard cluster on different infrastructure providers and with different configurations.
You can find further deployment instructions in specific directories. 

## Prerequisites

ThingsBoard is running on Kubernetes cluster, so you need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster.
[Here](https://kubernetes.io/docs/tasks/tools/) you can find a guide on how to install `kubectl` tool.

### Choose correct context

Make sure your `kubectl` tool is using the correct cluster context.
You can see all kubectl context and set the correct one using commands:

```
kubectl config get-contexts
kubectl config use-context THINGSBOARD_CONTEXT
```

Where `THINGSBOARD_CONTEXT` will be something like `thingsboard/SERVER_IP:SERVER_PORT/USER`.

## General info

After deploying the cluster you can log into the ThingsBoard using the following default credentials:

- **System Administrator**: sysadmin@thingsboard.org / sysadmin

If you installed DataBase with demo data (using `--loadDemo` flag) you can also use the following credentials:

- **Tenant Administrator**: tenant@thingsboard.org / tenant
- **Customer User**: customer@thingsboard.org / customer

In case of any issues, you can examine service logs for errors.
For example to see ThingsBoard node logs execute the following commands:

1) Get the list of the running tb-node pods:

`
kubectl get pods -l app=tb-node
`

2) Fetch logs of the tb-node pod:

`
kubectl logs -f [tb-node-pod-name]
`

Where:

- `tb-node-pod-name` - tb-node pod name obtained from the list of the running tb-node pods.

Or use `kubectl get pods` to see the state of all the pods.
Or use `kubectl get services` to see the state of all the services.
Or use `kubectl get deployments` to see the state of all the deployments.
See [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) command reference for details.