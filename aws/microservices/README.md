# AWS monolith deployment scripts

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Monolith mode on AWS cluster.

## Prerequisites

### Tools and roles configuration

Please follow [this](aws/README.md) instructions to configure required tools.

### Cluster configuration

If you don't have an AWS cluster, you'll need to create it.
In the `cluster.yml` file you can find suggested cluster configuration. 
Here are the fields you can change depending on your needs:
- `region` - should be the AWS region where you want your cluster to be located
- `availabilityZones` - should specify the exact IDs of the region's availability zones
- `instanceType` - the type of the instance with TB node (it's recommended to choose instance type with at least 4 CPU and 8 RAM)

Command to create AWS cluster:
```
eksctl create cluster -f cluster.yml
```

After cluster creation (or if you've already had it) you need to call this command to configure the cluster:
```
./aws-configure-cluster.sh
```

**Note:** You can delete AWS cluster with command:
```
eksctl delete cluster -r us-east-1 -n thingsboard-cluster -w
```

### PostgreSQL Configuration

You'll need to set up PostgreSQL on Amazon RDS. 
One of the ways to do it is by following [this](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SettingUp.html) guide.
**Note**: Make sure that `thingsboard` database is created along with PostgreSQL instance (or create it afterwards) 
and that your database can be connected from the cluster.

### Amazon MSK Configuration

You'll need to set up Amazon MSK.
You can do it by following [this](https://docs.aws.amazon.com/msk/latest/developerguide/getting-started.html) guide.


## Installation

Execute the following command to run the installation:

```
./k8s-install-tb.sh --loadDemo
```

Where:

- `--loadDemo` - optional argument. Whether to load additional demo data.

## Starting

Execute the following command to deploy resources:

```
./k8s-deploy-resources.sh
```

## Using

Now you can open ThingsBoard web interface in your browser using DNS name of the load balancer.

You can see DNS name of the load-balancers using command:

```
kubectl get service
```

There are two load-balancers:
- tb-loadbalancer-external - for MQTT and HTTP protocols
- tb-coap-loadbalancer-external - for COAP protocol

Use `EXTERNAL-IP` field of the load-balancers to connect to the cluster.

Or you can see this name on the ELB page.

Use the following default credentials:

- **System Administrator**: sysadmin@thingsboard.org / sysadmin

If you installed DataBase with demo data (using `--loadDemo` flag) you can also use the following credentials:

- **Tenant Administrator**: tenant@thingsboard.org / tenant
- **Customer User**: customer@thingsboard.org / customer

In case of any issues, you can examine service logs for errors.
For example to see ThingsBoard node logs execute the following commands:

1) Fetch logs of the tb-node pod:

```
kubectl logs -f tb-node-0
```

Or use `kubectl get pods` to see the state of the pod.
Or use `kubectl get services` to see the state of all the services.
Or use `kubectl get deployments` to see the state of all the deployments.
See [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) command reference for details.

Execute the following command to delete **tb-node** and **load-balancers**:

```
./k8s-delete-resources.sh
```

Execute the following command to delete  **tb-node**, **load-balancers** and **configmaps**:

```
./k8s-delete-all.sh
```

## Upgrading

In case when database upgrade is needed, execute the following commands:

```
./k8s-delete-resources.sh
./k8s-upgrade-tb.sh --fromVersion=[FROM_VERSION]
./k8s-deploy-resources.sh
```

Where:

- `FROM_VERSION` - from which version upgrade should be started. See [Upgrade Instructions](https://thingsboard.io/docs/user-guide/install/upgrade-instructions) for valid `fromVersion` values.
