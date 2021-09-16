# AWS deployment scripts

Here you can find scripts for different deployment scenarios using AWS platform:

- [**monolith**](https://thingsboard.io/docs/user-guide/install/cluster/aws-monolith-setup/) - simplistic deployment of ThingsBoard monolith 
with [Amazon RDS for PostgreSQL](https://aws.amazon.com/rds/postgresql/). 
Recommended for deployment scenarios that may sacrifice high availability to **optimize the cost**. 
- [**microservices**](https://thingsboard.io/docs/user-guide/install/cluster/aws-microservices-setup/) - deployment of ThingsBoard microservices 
with [Amazon RDS for PostgreSQL](https://aws.amazon.com/rds/postgresql/), [Amazon MSK](https://aws.amazon.com/msk/) 
and [ElastiCache for Redis](https://aws.amazon.com/elasticache/redis/). Recommended for **scalable and highly available** deployments. 
- [**custom-microservices**](https://thingsboard.io/docs/user-guide/install/cluster/aws-custom-microservices-setup/) - deployment of ThingsBoard microservices 
alongside with self-managed PostgreSQL, Kafka and Redis.


## Prerequisites

For each of the AWS use-cases you will need to have `kubectl`, `eksctl` and `awscli` tools installed.
Here you can find installation guides:

- for [kubectl](https://kubernetes.io/docs/tasks/tools/)
- for [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- for [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

Afterwards you need to configure Access Key, Secret Key and default region. 
To get Access and Secret keys please follow [this](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) guide.
The default region should be the ID of the region where you'd like to deploy the cluster.

```
aws configure
```

Note that you also need to set `ACCOUNT_ID` property in `.env` file.
[Here](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html#FindingYourAWSId) a guide how to find your account ID.
