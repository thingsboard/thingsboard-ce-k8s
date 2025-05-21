#!/bin/bash

set -e

evp_mqtt_image="${1:-$EVP_MQTT_IMAGE}"
git_branch="helmrepo"

if [[ -z "$evp_mqtt_image" ]]
then
  echo "the evp_mqtt_image must not be empty"
  exit 1
fi

set -x

echo Git branch: "$git_branch"

values_file=helm/thingsboard/values.yaml
if [[ "$evp_mqtt_image" ]]
then
  yq -i e '.mqtt.evpImage="'"$evp_mqtt_image"'"' "$values_file"
fi

git commit -a -m "bump evp-mqtt image to $evp_mqtt_image"
git push --set-upstream origin "$git_branch"
