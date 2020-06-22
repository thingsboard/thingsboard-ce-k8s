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

set -e

source .env

if [ "$PLATFORM" == "minikube" ]; then
    kubectl apply -f common/tb-namespace.yml
fi

kubectl config set-context $(kubectl config current-context) --namespace=thingsboard

kubectl apply -f common/tb-node-configmap.yml
kubectl apply -f common/tb-mqtt-transport-configmap.yml
kubectl apply -f common/tb-http-transport-configmap.yml
kubectl apply -f common/tb-coap-transport-configmap.yml
kubectl apply -f common/thingsboard.yml
kubectl apply -f $DEPLOYMENT_TYPE/tb-node-cache-configmap.yml
kubectl apply -f common/tb-node.yml


if [ "$PLATFORM" == "minikube" ]; then
    kubectl apply -f $PLATFORM/routes.yml
elif [ "$PLATFORM" == "openshift" ]; then
    oc create -f $PLATFORM/routes.yml
elif [ "$PLATFORM" == "aws" ]; then
    kubectl apply -f $PLATFORM/routes.yml
else
    echo "No routes for platform $PLATFORM"
fi

