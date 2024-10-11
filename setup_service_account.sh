#!/bin/bash

echo $SVC_ACCOUNT_KEY | base64 -d > ./service-account.json
gcloud auth activate-service-account --key-file=./service-account.json

