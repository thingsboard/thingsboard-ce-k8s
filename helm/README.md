# Helm chart for deploying Thingsboard in Kubernetes
This folder contains a helm chart that can be used to deploy Thingsboard on any Kubernetes cluster

## Some examples
* Simple deployment
```
helm install --create-namespace -n thingsboard thingsboard thingsboard
```
* Hybrid database (Cassandra for timeseries)
```
helm install --create-namespace -n thingsboard thingsboard thingsboard \
  --set cassandra.enabled=true
```
* Hybrid database and set passwords
```
helm install --create-namespace -n thingsboard thingsboard thingsboard \
  --set cassandra.enabled=true \
  --set postgresql-ha.postgresql.password=SET \
  --set postgresql-ha.postgresql.repmgrPassword=REALLY \
  --set postgresql-ha.pgpool.adminPassword=SECURE \
  --set redis.auth.password=PASSWORDS \
  --set cassandra.dbUser.password=HERE
```
* Tune number of replicas
```
helm install --create-namespace -n thingsboard thingsboard thingsboard \
  --set mqtt.replicaCount=3 \
  --set http.replicaCount=0 \
  --set coap.replicaCount=0
```
* Enable ingress and TLS for API REST (requirements `cert-manager` and `nginx-ingress`)
```
helm install --create-namespace -n thingsboard thingsboard thingsboard \
  --set ingress.enabled=true \
  --set ingress.tls=true \
  --set ingress.hosts[0]=my-host.example.com \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt \
  --set-string ingress.annotations."nginx\.ingress\.kubernetes\.io/proxy-read-timeout"=3600 \
  --set-string ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-redirect"=true \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set-string ingress.annotations."nginx\.ingress\.kubernetes\.io/use-regex"=true
```
* Enable MQTT SSL (requirements: public and private keys in a Kubernetes secret with key name being `tls.key` and `tls.crt` respectively, for example by using `cert-manager`)
```
cat << EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: mqtt
  namespace: thingsboard
spec:
  secretName: mqtt-tls-secret
  dnsNames:
    - my-mqtt-host.example.com
  issuerRef:
    name: letsencrypt-dns
    kind: ClusterIssuer
    group: cert-manager.io
  usages:
  - digital signature
  - key encipherment
EOF

helm install --create-namespace -n thingsboard thingsboard thingsboard \
  --set mqtt.ssl.enabled=true \
  --set mqtt.ssl.secret=mqtt-tls-secret \
```
## All options
* For the full list of options of this helm chart:
```
helm inspect values thingsboard
```
* For the list of values of this chart dependencies:
  * cassandra: https://github.com/bitnami/charts/blob/master/bitnami/cassandra/values.yaml
  * kafka: https://github.com/bitnami/charts/blob/master/bitnami/kafka/values.yaml
  * postgresql-ha: https://github.com/bitnami/charts/blob/master/bitnami/postgresql-ha/values.yaml
  * valkey: https://github.com/bitnami/charts/blob/master/bitnami/valkey/values.yaml

