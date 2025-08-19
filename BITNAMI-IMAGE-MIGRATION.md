# Action Required: Migration from Bitnami Public Container Images

## Overview (TL;DR)

*   **What:** Bitnami is archiving most of its free, versioned container images.
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

To perform an audit where bitnami images are used, run the following command:
```bash
kubectl get pods -A -o jsonpath='{range .items[*]}{"\n"}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{range .spec.containers[*]}{.image}{", "}{end}{"\n"}{end}' | grep -E "bitnami"
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

* [bitnami/valkey](https://hub.docker.com/r/bitnami/valkey) => [valkey/valkey](https://hub.docker.com/r/valkey/valkey)
* [bitnami/kafka](https://hub.docker.com/r/bitnami/kafka) => [apache/kafka](https://hub.docker.com/r/apache/kafka)
