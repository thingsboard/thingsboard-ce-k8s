## Motivation to rewrite bitnami repo with clusterpolicies.kyverno.io

This solution helps to address bitnami repo issue and grant some time to move to alternative images

See: https://github.com/bitnami/charts/issues/35164

## Kyverno - Cloud Native Policy Management

Documentation: https://github.com/kyverno/kyverno

Install Kyverno with the cluster policy `rewrite-bitnami-to-bitnamilegacy.yml`

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update kyverno
helm search repo kyverno/kyverno --versions
helm show chart kyverno/kyverno --version 3.5.0

helm upgrade --install kyverno kyverno/kyverno -n kyverno --create-namespace --version 3.5.0 --set admissionController.replicas=2

kubectl -n kyverno get pods
kubectl get crds | grep kyverno

kubectl apply -f rewrite-bitnami-to-bitnamilegacy.yml
kubectl get clusterpolicies.kyverno.io
```

## Inventory your bitnami repo usage

Before you started, please do the inventory

```bash
kubectl get pods -A -o json \
  | jq -r '
    .items[]
    | {ns: .metadata.namespace, pod: .metadata.name, images: (
        [
          (.spec.containers // []),
          (.spec.initContainers // []),
          (.spec.ephemeralContainers // [])
        ]
        | add
        | map(select(.image? != null))
        | map(.image)
        | map(select(test("^(docker\\.io/)?bitnami/")))
        | unique
      )}
    | select(.images | length > 0)
    | "\(.ns)\t\(.pod)\t\(.images | join(", "))"
  '
```

Output expected:

```bash
thingsboard	cassandra-0	        bitnami/cassandra-exporter:2.3.8-debian-11-r421
thingsboard	postgres-0	        docker.io/bitnami/postgresql:15.4.0-debian-11-r5
thingsboard	kafka-controller-0	docker.io/bitnami/kafka:4.0.0-debian-12-r0
thingsboard	redis-cluster-0	    docker.io/bitnami/os-shell:11-debian-11-r19, docker.io/bitnami/redis-cluster:7.0.12-debian-11-r15, docker.io/bitnami/redis-exporter:1.52.0-debian-11-r0
thingsboard	zookeeper-0	        docker.io/bitnami/zookeeper:3.8.2-debian-11-r7
```

## How it works ?

It rewrites yaml on the fly so you need only restart your bitnami containers to switch to the bitnamilegacy repo

```bash
thingsboard   0s          Normal    Pulling             pod/postgres-0                          Pulling image "bitnamilegacy/postgresql:15.4.0-debian-11-r5"
```

Important: this is a temporary solution for gentle migration only

## Other options

Some older images might not migrate to a new bitnamilegacy repo.

You can copy multi-arch images to your private repo with a single command (replace `yourcustomrepo` name)

```bash
docker buildx imagetools create --tag docker.io/yourcustomrepo/cassandra:3.11.13-debian-10-r20 docker.io/bitnami/cassandra:3.11.13-debian-10-r20
```
