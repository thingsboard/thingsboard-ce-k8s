# AWS deployment scripts

Here you can find scripts for different deployment scenarios using AWS platform:

- **monolith** - simplistic deployment of ThingsBoard monolith with external PostgreSQL (it's recommended to use Amazon RDS for PostgreSQL)
- **microservices** - deployment of ThingsBoard microservices with external PostgreSQL, Kafka and Redis (it's recommended to use Amazon-managed solutions)
- **custom-microservices** - deployment of ThingsBoard microservices alongside with PostgreSQL, Kafka and Redis


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

If you want to be able to connect to the nodes via SSH you'll need to generate SSH key:
```
aws ec2 create-key-pair --key-name aws-key-pair --query "KeyMaterial" --output text > aws-key-pair.pem
ssh-keygen -y -f aws-key-pair.pem > aws-key-public.pub
mv aws-key-public.pub ~/.ssh/aws_rsa.pub
```

Note that you also need to set `ACCOUNT_ID` property in `.env` file.
[Here](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html#FindingYourAWSId) a guide how to find your account ID.
