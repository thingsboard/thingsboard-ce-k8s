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

    kubectl apply -f tb-node-db-configmap.yml

    kubectl apply -f tb-node-configmap.yml
    kubectl apply -f database-setup.yml &&
    kubectl wait --for=condition=Ready pod/tb-db-setup --timeout=120s &&
    kubectl exec tb-db-setup -- sh -c 'export INSTALL_TB=true; export LOAD_DEMO='"$loadDemo"'; start-tb-node.sh; touch /tmp/install-finished;'

    kubectl delete pod tb-db-setup

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

kubectl apply -f tb-namespace.yml || echo
kubectl config set-context $(kubectl config current-context) --namespace=thingsboard


installTb ${loadDemo}

