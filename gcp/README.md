# Kubernetes resources configuration for ThingsBoard Microservices

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Kubernetes cluster that is running on Google Cloude Platform.

## Prerequisites

ThingsBoard Microservices run on the Kubernetes cluster.
You need to install a gcloud, kops, terraform (v0.11+) and the kubectl (v1.16+).

[gcloud](https://cloud.google.com/sdk/gcloud) - for manage GCP infrastructure.

[kops](https://github.com/kubernetes/kops) - for create and manage kubernetes cluster.

[terraform](https://www.terraform.io/) - for create and manage cloud infrastructure in GCP.

You can choose any other available [Kubernetes cluster deployment solutions](https://kubernetes.io/docs/setup/pick-right-solution/).

### Enter the terraform working directory

`
$ cd ./gcp
`

### GCP credentials and access
Also you need access to GCP.

To login, please execute the following command:

`
$ gcloud auth application-default login
`

Get your project id:

`
$ gcloud projects list
`

To set your project for k8s cluster, please execute following command:

`
$  gcloud config set project $your_project_id
`

### Installation GCP cloud infrastructure
To create a service account, a storage bucket and a rules for a k8s cluster, please create variables file:

```
$ cat << EOF > terraform.tfvars
project     = "$your_project_id"
svca_name   = "$name_for_new_service_account"
bucket_name = "$bucket_name_for_kops"
vpc_name    = "$vpc_name"
EOF
```

To initialize terraform states, please execute the following command:

`
terraform init
`

To review what infrastructure will be created, please execute the following command:

`
terraform plan
`

To create infrastructure for the k8s cluster, please execute the following command:

`
terraform apply
`

In output of this command you will have your bucket name and service account email.

To get your service account id, email, name with gcloud, please execute the following command:

`
$ gcloud iam service-accounts list
` 

To create a new json key for your service account, please execute the following command:

`
$ gcloud iam service-accounts keys create --iam-account $serviceAccountEMAIL kops-cluster-gcp-key.json
`

To export a JSON file content of the created service account json key, please execute the following command:

`
$ export GOOGLE_CREDENTIALS=$(cat ./kops-cluster-gcp-key.json)
`

To create the k8s cluster, please execute the following commands:

```
$ PROJECT=$your_project_id
$ export KOPS_FEATURE_FLAGS=AlphaAllowGCE # to unlock the GCE features
$ kops create cluster kops-example-dev.k8s.local --zones=us-central1-a,us-central1-b,us-central1-c --gce-service-account $serviceAccountEMAIL --vpc $vpc_name --state gs://$bucket_name_for_kops/ --project=${PROJECT} --kubernetes-version=1.18.0 --node-count 3 --node-size n2-standard-4
```

If you want a high-available cluster, please add this option to the last command:

`
--master-count 3
--master-zones=us-central1-a,us-central1-b,us-central1-c
--node-count 6
--node-size n2-standard-4
`

To get the k8s cluster name from the bucket, please execute following command:

`
$ kops get cluster --state gs://$bucket_name_for_kops/
`

To deploy the cluster to the gcp infrastructure, please execute following command:

`
$ kops update cluster kops-example-dev.k8s.local --state gs://$bucket_name_for_kops/ --yes
`

To check status of your cluster, please execute following command:

`
$ kops validate cluster --wait 10m --state gs://$bucket_name_for_kops/
`

After that you can check your nodes:

`
$ kubectl get ndoes
`

If you want to export a kubectl config, please execute following command:

`
$ kops export kubecfg kops-example-dev.k8s.local
`

To destroy the k8s cluster, please execute following commands:

```
$ kops delete cluster kops-example-dev.k8s.local --state gs://$bucket_name_for_kops/ --yes
$ export GOOGLE_CREDENTIALS=""
$ terraform destroy
```