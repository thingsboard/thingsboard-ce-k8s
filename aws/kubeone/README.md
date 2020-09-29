# Kubernetes resources configuration for ThingsBoard Microservices

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Kubernetes cluster that is running on AWS.

## Prerequisites

ThingsBoard Microservices run on the Kubernetes cluster.
You need to install a kubeone (v1.0+), terraform (v0.12+) and the kubectl (v1.16+).

[kubeOne](https://docs.kubermatic.com/kubeone/master/) - for create and manage kubernetes cluster.

[terraform](https://www.terraform.io/) - for create and manage cloud infrastructure in AWS.

You can choose any other available [Kubernetes cluster deployment solutions](https://kubernetes.io/docs/setup/pick-right-solution/).

### Enter the terraform working directory

`
cd ./aws
`

### Generate ssh key

Kubeone needs ssh key for access to ec2 instance. By default, terraform uses ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub. But you can generate your ssh key to any folder and add this path to terraform variables file.
To generate ssh key, please execute the following command:

`
ssh-keygen
` 

### AWS credentials
Also you need access to AWS. It can be iam user or iam role. You need have a AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY.
To add environment variables, please execute the following command:

`
export AWS_PROFILE=default
`

`
export AWS_ACCESS_KEY=xxxxxxxxx
`

`
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxx
`

### Installation AWS cloud infrastructure

To initialize a working directory for terraform, please execute the following command:

`
terraform init
`

To create configure file for terraform, please execute the following command:

`
nano terraform.tfvars
`

And add this example config:
```
cluster_name = "k8s-cluster-example"
aws_region = "eu-west-1"
control_plane_type = "t3.medium"
```
Now we use this example config, but you can see all the variables in `variables.tf`.

To see what infrastructure will be created, please execute the following command:

`
terraform plan
`

To create this infrastructure, please execute the following command:

`
terraform apply
`

After executing this command we will have the infrastructure to create the k8s cluster.
For kubeone, we need to generate terraform output file with all resourse id. Please execute the following command:

`
terraform output -json > tf.state
`

Generate config file for kubeone. Please execute the following command:

`
kubeone config print --full > config.yml
`

Please change kubernetes version for 1.18.0. 
Also you can change the settings for yourself. We will use default config.

To add your ssh key to ssh agent, please execute the following command:

`
ssh-add /path/to/your/id_rsa
`

To start deploy k8s cluster, please execute the following command:

`
kubeone install -m config.yml -t tf.state
`

After executing this command you will have a working k8s cluster with three master nodes and kubeconfig for your kubectl in this directory  $(pwd)/ .

To set KUBECONFIG variable for kubectl, please execute the following command:

`
export KUBECONFIG=$(pwd)/k8s-cluster-example-kubeconfig
`

And check your nodes in the cluster:

`
kubectl get nodes 
`

For manage workers node kubeone uses machinedeployments, please execute the following command:

`
kubectl get machinedeployments -n kube-system
`

To scale your workers node, please execute the following command:

`
kubectl --namespace kube-system scale machinedeployment/<MACHINE-DEPLOYMENT-NAME> --replicas=3
`

To remove k8s cluster and aws resourse, you can execute the following command:

```
kubeone reset -m config.yml -t tf.state
terraform destroy
```