#!/bin/bash

SONARCLOUD_API_TOKEN=$1
SONARCLOUD_ORGANIZATION=$2
GATE_NAME=$3

gate_id=$(curl -s -u ${SONARCLOUD_API_TOKEN}: "https://sonarcloud.io/api/qualitygates/show" -d "organization=${SONARCLOUD_ORGANIZATION}" | jq -r '.qualitygates[] | select(.name=="'"$GATE_NAME"'") | .id')

echo "$gate_id"