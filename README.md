# Kubernetes resources configuration for ThingsBoard

Here you can find scripts for deployment on different Kubernetes platforms.

# Midokura notes

This fork is expected to be in sync with [Thingsboard upstream](https://github.com/thingsboard/thingsboard).

Most of Midokura changes will be related to the official Midokura way to deploy
Thingsboard that is Helm chart (code inside `helm/` directory).

Code for other deployments (`aws/`, `azure/`, `gcp`, `minikube`, `openshift`
and maybe others in the future) WILL NOT include Midokura specific changes, and
it is just left here to make upstream syncing easier.

If you are a Midokura engineer you SHOULD use only the contents in `helm/`
directory. Other options may miss important changes for production environment
and should be avoided.
