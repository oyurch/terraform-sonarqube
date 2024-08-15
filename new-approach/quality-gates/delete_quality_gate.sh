#!/bin/bash

SONARCLOUD_API_TOKEN=$1
SONARCLOUD_ORGANIZATION=$2
GATE_NAME=$3

gate_id=$(curl -s -u ${SONARCLOUD_API_TOKEN}: "https://sonarcloud.io/api/qualitygates/show" -d "organization=${SONARCLOUD_ORGANIZATION}" | jq -r --arg GATE_NAME "$GATE_NAME" '.qualitygates[] | select(.name==$GATE_NAME) | .id')

if [ -n "$gate_id" ]; then
  curl -X POST \
  -u ${SONARCLOUD_API_TOKEN}: \
  "https://sonarcloud.io/api/qualitygates/delete" \
  -d "id=$gate_id"
fi