# Action Required: Migration from Bitnami Public Container Images

## Overview (TL;DR)

*   **What:** Bitnami is archiving most of its free, versioned container images: [Upcoming changes to the Bitnami catalog](https://github.com/bitnami/charts/issues/35164)
*   **When:** The change is effective **August 28th, 2025**.
*   **Impact:** Deployments using `bitnami/kafka` and `bitnami/valkey` from this repository **will fail** after the deadline.
*   **Action:** You must update your deployment manifests. This document outlines temporary workarounds and the recommended long-term solution.

## Summary of the Problem

Effective **August 28th, 2025**, Bitnami is significantly changing its public image catalog. The majority of free container images, including all versioned tags (e.g., `12.0.0`), will be moved from the primary `docker.io/bitnami` repository to an archival repository at `docker.io/bitnamilegacy`.

**Key Implications:**

*   **No More Updates:** The `bitnamilegacy` repository will be frozen. Images stored there will **not** receive any security patches, bug fixes, or updates.
*   **Broken Deployments:** Any deployment that depends on specific image versions from the `docker.io/bitnami` repository will fail with `ImagePullBackOff` errors after this date, as the images will no longer be found at their original location.
*   **Limited Free Tier:** The main `docker.io/bitnami` repository will only host a small, limited subset of free, hardened images, available only with the `latest` tag.

## How This Project is Affected

Thingsboard has a direct dependency on thirdparty services within the cluster that use Bitnami images. Although the core components of ThingsBoard use the official thingsboard/* images, this affects the manifests for the following services:

| Service        | Affected Image         | Known Affected Manifests                                                                                                                            |
| :------------- | :--------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| Kafka          | `bitnami/kafka:4.0.0`  | `aws/microservices/tb-kafka.yml`, `azure/microservices/thirdparty.yml`, `gcp/microservices/thirdparty.yml`, `minikube/thirdparty.yml`, `openshift/thirdparty.yml` |
| Valkey (Redis) | `bitnami/valkey:8.0`   | `aws/microservices/tb-valkey.yml`, `azure/microservices/thirdparty.yml`, `gcp/microservices/thirdparty.yml`, `minikube/thirdparty.yml`, `openshift/thirdparty.yml` |

**All deployments using these manifests will fail to pull images after August 28, 2025.**

## How to Audit Your Cluster

To perform an audit where bitnami images are used in the k8s cluster, run the following command:
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

To check the Docker deployment, use the next command:
```bash
docker ps -a | grep "bitnami/"
```

Then check the availability of the image on Docker Hub.

* Option 1: Using docker pull
    ```bash
    docker pull bitnamilegacy/kafka:4.0.0
    ```
* Option 2: Using an HTTP request (cURL). This is useful for scripting or in environments without a Docker daemon:
    ```bash
    DOCKER_REPOSITORY=bitnamilegacy/kafka
    TAG=4.0.0
    curl -sfL "https://hub.docker.com/v2/repositories/${DOCKER_REPOSITORY}/tags/${TAG}" > /dev/null \
     && echo "Image ${DOCKER_REPOSITORY}/${TAG} exists" \
     || echo "Image ${DOCKER_REPOSITORY}/${TAG} does not exist"
    ```

## Recommended Actions

Users who deploy Kafka or Valkey using the provided manifests **must take action** to avoid service disruption.

### 1. Temporary Workaround (bitnamilegacy repository)

To ensure your deployments continue to function temporarily after the deadline, you must modify the manifests to pull from the `bitnamilegacy` repository.

**In all affected YAML files, make the following changes:**

```yaml
# Change this:
image: bitnami/kafka:4.0.0

# To this:
image: bitnamilegacy/kafka:4.0.0

# For Valkey, change this:
image: bitnami/valkey:8.0

# To this:
image: bitnamilegacy/valkey:8.0
```

You can use [Kyverno](https://github.com/kyverno/kyverno) for automatic image replacement. Kyverno is a Kubernetes-native policy engine. In this case, it can be used to overwrite bitnami in the bitnamilegacy docker repo on the fly. https://github.com/thingsboard/thingsboard-ce-k8s/pull/157

### 2. Temporary Workaround (private repository)



You can copy multi-arch Docker repo to your private repo (example public bitnami to private repo)
```bash
docker buildx imagetools create --tag docker.io/YOUR_PRIVATE_REPO/kafka:4.0.0 docker.io/bitnami/kafka:4.0.0
```

### 3. Long-Term Production Solution

For continued security, support, and access to updated versions, you should switch to a different image provider. Replace the Bitnami image with a reliable alternative, such as the official images from [Valkey](https://hub.docker.com/r/valkey/valkey).

We are working on this change and will soon replace all Bitnami images to ensure the latest security updates and support.

**Roadmap:**
* redis => [valkey/valkey](https://hub.docker.com/r/valkey/valkey)
* [bitnami/valkey](https://hub.docker.com/r/bitnami/valkey) => [valkey/valkey](https://hub.docker.com/r/valkey/valkey)
* [bitnami/valkey-cluster](https://hub.docker.com/r/bitnami/valkey-cluster) => ?
* [bitnami/valkey-sentinel](https://hub.docker.com/r/bitnami/valkey-sentinel) => ?
* [bitnami/redis-exporter](https://hub.docker.com/r/bitnami/redis-exporter) =>  ?
* [bitnami/kafka](https://hub.docker.com/r/bitnami/kafka) => [apache/kafka](https://hub.docker.com/r/apache/kafka)
* [bitnami/kafka-exporter](https://hub.docker.com/r/bitnami/kafka-exporter) =>  [danielqsj/kafka-exporter](https://hub.docker.com/r/danielqsj/kafka-exporter)
* [bitnami/cassandra](https://hub.docker.com/r/bitnami/cassandra) =>  [cassandra/cassandra](https://hub.docker.com/_/cassandra)
* [bitnami/cassandra-exporter](https://hub.docker.com/r/bitnami/cassandra-exporter) =>  ?
* [bitnami/zookeeper](https://hub.docker.com/r/bitnami/zookeeper) => [zookeeper/zookeeper](https://hub.docker.com/_/zookeeper)
* [bitnami/postgresql](https://hub.docker.com/r/bitnami/postgresql) => [postgres/postgres](https://hub.docker.com/_/postgres)
* [bitnami/kubectl](https://hub.docker.com/r/bitnami/kubectl) => [portainer/kubectl-shell](https://hub.docker.com/r/portainer/kubectl-shell) or [rancher/kubectl](https://hub.docker.com/r/rancher/kubectl)

### 4. Affected ThingsBoard GitHub repositories

* [thingsboard/thingsboard](https://github.com/thingsboard/thingsboard)
* [thingsboard/thingsboard-pe-docker-compose](https://github.com/thingsboard/thingsboard-pe-docker-compose)
* [thingsboard/thingsboard-ce-k8s](https://github.com/thingsboard/thingsboard-ce-k8s)
* [thingsboard/thingsboard-pe-k8s](https://github.com/thingsboard/thingsboard-pe-k8s)
* [thingsboard/thingsboard-edge](https://github.com/thingsboard/thingsboard-edge)
* [thingsboard/thingsboard-edge-pe-docker-compose](https://github.com/thingsboard/thingsboard-edge-pe-docker-compose)
* [thingsboard/tbmq](https://github.com/thingsboard/tbmq)
* [thingsboard/helm-charts](https://github.com/thingsboard/helm-charts)
* [thingsboard/charts](https://github.com/thingsboard/charts)
* [thingsboard/thingsboard.github.io](https://github.com/thingsboard/thingsboard.github.io)
* [thingsboard/docker](https://github.com/thingsboard/docker)
