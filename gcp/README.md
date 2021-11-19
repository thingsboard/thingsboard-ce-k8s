# GCP deployment scripts

Here you can find scripts for different deployment scenarios using GCP:

- [**monolith**](https://thingsboard.io/docs/user-guide/install/cluster/gcp-monolith-setup/) - simplistic deployment of ThingsBoard monolith
- [**microservices**](https://thingsboard.io/docs/user-guide/install/cluster/gcp-microservices-setup/) - deployment of ThingsBoard microservices


# GCP Create cluster command

# Zone cluster

gcloud container clusters create tb-ce \
--release-channel stable \
--zone us-central1-a \
--node-locations us-central1-a \
--num-nodes=1 \
--machine-type=e2-standard-4

gcloud container clusters delete thingsboard --region us-central1

e2-standard-4

## Region cluster

gcloud container clusters create thingsboard \
--region us-central1 \
--release-channel stable

gcloud container clusters delete thingsboard --region us-central1

# PostgreSQL

thingsboard
p3lGA8tkLHvMFhOy

gcloud sql instances create thingsboard-db \
--database-version=POSTGRES_12 \
--region=us-central1 \
--availability-type=regional \
--cpu=2 \
--memory=7680MB

gcloud sql users set-password postgres \
--instance=thingsboard-db \
--password=secret
