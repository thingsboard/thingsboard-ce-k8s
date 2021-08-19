# AWS deployment scripts

Here you can find scripts for different deployment scenarios using AWS platform:

- **monolith** - simplistic deployment of ThingsBoard monolith with external PostgreSQL (it's recommended to use Amazon RDS for PostgreSQL)
- **microservices** - deployment of ThingsBoard microservices with external PostgreSQL, Kafka and Redis (it's recommended to use Amazon-managed solutions)
- **custom-microservices** - deployment of ThingsBoard microservices alongside with PostgreSQL, Kafka and Redis


## Prerequisites

For any deployment mode you need to configure Kubernetes infrastructure first of all.


After configuring AWS, you can continue the installation from this step.

- ./aws/kubeone - KubeOne automates cluster operations on all your aws instances. KubeOne can install high-available (HA) master clusters as well single master clusters.

- ./aws/eks - Amazon EKS is a completely AWS-managed Kubernetes service.
