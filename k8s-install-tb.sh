#!/bin/bash
#
# Copyright © 2016-2020 The Thingsboard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

function installTb() {

    loadDemo=$1

    kubectl apply -f $DEPLOYMENT_TYPE/$DATABASE/tb-node-db-configmap.yml

    kubectl apply -f common/tb-node-configmap.yml
    kubectl apply -f common/database-setup.yml &&
    kubectl wait --for=condition=Ready pod/tb-db-setup --timeout=120s &&
    kubectl exec tb-db-setup -- sh -c 'export INSTALL_TB=true; export LOAD_DEMO='"$loadDemo"'; start-tb-node.sh; touch /tmp/install-finished;'

    kubectl delete pod tb-db-setup

}

function installPostgres() {

    if [ "$DEPLOYMENT_TYPE" == "high-availability" ]; then
        if [ "$PLATFORM" == "openshift" ]; then
          export PG_UID=$(kubectl get project thingsboard -o jsonpath='{.metadata.annotations.openshift\.io\/sa\.scc\.uid-range}' | cut -d'/' -f 1)
        else
          export PG_UID=1001
        fi

        echo "Starting PostgreSQL as $PG_UID user."
        kubectl apply -f $DEPLOYMENT_TYPE/pgpool-configmap.yml
        helm repo add bitnami https://charts.bitnami.com/bitnami
        helm install my-release -f $DEPLOYMENT_TYPE/postgres-ha.yaml \
            --set pgpool.securityContext.runAsUser=$PG_UID --set pgpool.securityContext.fsGroup=$PG_UID \
            --set metrics.securityContext.runAsUser=$PG_UID \
            --set postgresql.securityContext.runAsUser=$PG_UID --set postgresql.securityContext.fsGroup=$PG_UID \
             bitnami/postgresql-ha
        kubectl rollout status statefulset my-release-postgresql-ha-postgresql
        kubectl rollout status deployment my-release-postgresql-ha-pgpool
    else
        kubectl apply -f $DEPLOYMENT_TYPE/postgres.yml
        kubectl rollout status deployment/postgres
    fi
}

function installCassandra() {

    if [ $CASSANDRA_REPLICATION_FACTOR -lt 1 ]; then
        echo "CASSANDRA_REPLICATION_FACTOR should be greater or equal to 1. Value $CASSANDRA_REPLICATION_FACTOR is not allowed."
        exit 1
    fi

    kubectl apply -f common/cassandra.yml

    kubectl rollout status statefulset/cassandra

    kubectl exec -it cassandra-0 -- bash -c "cqlsh -u cassandra -p cassandra -e \
                    \"CREATE KEYSPACE IF NOT EXISTS thingsboard \
                    WITH replication = { \
                        'class' : 'SimpleStrategy', \
                        'replication_factor' : $CASSANDRA_REPLICATION_FACTOR \
                    };\""
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --loadDemo)
    LOAD_DEMO=true
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ "$LOAD_DEMO" == "true" ]; then
    loadDemo=true
else
    loadDemo=false
fi

source .env

kubectl apply -f common/tb-namespace.yml || echo
kubectl config set-context $(kubectl config current-context) --namespace=thingsboard

if [ "$PLATFORM" == "aws" ]; then
  kubectl apply -f common/storageclass.yml
  kubectl apply -f common/ingress.yml
fi

if [ "$PLATFORM" == "aws-eks" ]; then
  kubectl delete sc gp2 || echo
  kubectl apply -f common/storageclass.yml
  kubectl apply -f common/ingress.yml
fi

if [ "$PLATFORM" == "gcp" ]; then
  kubectl apply -f aws/ingress.yml
fi

case $DEPLOYMENT_TYPE in
        basic)
        ;;
        high-availability)
        ;;
        *)
        echo "Unknown DEPLOYMENT_TYPE value specified: '${DEPLOYMENT_TYPE}'. Should be either basic or high-availability." >&2
        exit 1
esac

case $DATABASE in
        postgres)
            installPostgres
            installTb ${loadDemo}
        ;;
        hybrid)
            installPostgres
            installCassandra
            installTb ${loadDemo}
        ;;
        *)
        echo "Unknown DATABASE value specified: '${DATABASE}'. Should be either postgres or hybrid." >&2
        exit 1
esac

