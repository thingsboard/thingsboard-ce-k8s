# GCP deployment scripts

Here you can find scripts for different deployment scenarios using GCP:

- **monolith** - simplistic deployment of ThingsBoard monolith
- **microservices** - deployment of ThingsBoard microservices


## Prerequisites


Setup a simple GCP cluster please follow [this](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster) guide.

To update context of Kubectl execute this command:

```
source .env
gcloud container clusters get-credentials $CLUSTER_NAME
```
