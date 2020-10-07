# Kubernetes resources configuration for ThingsBoard Microservices

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Kubernetes cluster that is running on AWS EKS.

## Prerequisites

ThingsBoard Microservices run on the Kubernetes cluster.
You need to install a terraform (v0.12+) and the kubectl (v1.16+).

[terraform](https://www.terraform.io/) - for create and manage cloud infrastructure in AWS EKS.

You can choose any other available [Kubernetes cluster deployment solutions](https://kubernetes.io/docs/setup/pick-right-solution/).

### Enter the terraform working directory

`
cd ./aws/eks
`

### AWS credentials
Also you need access to AWS. It can be iam user or iam role. You need have a AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY.
To add environment variables, please execute the following command:

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
worker_type = "t3.medium"
cluster_version = "1.17"
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

We will get cluster_name from the output of this command.
And after executing this command we will have the k8s cluster.

To set KUBECONFIG variable for kubectl, please execute the following command:

`
export KUBECONFIG=$(pwd)/[your_kubeconfig_thingsboard_name]
`

And check your nodes in the cluster:

`
kubectl get nodes 
`

To scale your nodes you need to install "cluster_autoscaler". Please, change "cluster_name" in `../../common/cluster-autoscaler-autodiscover.yaml`, 
and please execute the following command for install "cluster_autoscaler":

`
kubectl apply -f ../../common/cluster-autoscaler-autodiscover.yaml
`

To remove k8s cluster and aws resourse, you can execute the following command:

```
terraform destroy
```