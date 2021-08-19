# AWS monolith deployment scripts

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Monolith mode on AWS cluster.


## Prerequisites

Please follow [this](aws/README.md) instructions to set up the Kubernetes cluster.

## Installation

Execute the following command to run the installation:

`
./k8s-install-tb.sh --loadDemo
`

Where:

- `--loadDemo` - optional argument. Whether to load additional demo data.

## Running

Execute the following command to deploy resources:

`
./k8s-deploy-resources.sh
`

Now you can open ThingsBoard web interface in your browser using dns name of the load balancer.

You can see DNS name of the loadbalancer using command:

`
kubectl get ingress -oyaml
`

Or you can see this name on the ELB page.

You should see the ThingsBoard login page.

Use the following default credentials:

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

Execute the following command to delete all ThingsBoard microservices:

`
./k8s-delete-resources.sh
`

Execute the following command to delete all resources (including database):

`
./k8s-delete-all.sh
`

## Upgrading

In case when database upgrade is needed, execute the following commands:

```
./k8s-delete-resources.sh
./k8s-upgrade-tb.sh --fromVersion=[FROM_VERSION]
./k8s-deploy-resources.sh
```

Where:

- `FROM_VERSION` - from which version upgrade should be started. See [Upgrade Instructions](https://thingsboard.io/docs/user-guide/install/upgrade-instructions) for valid `fromVersion` values.
