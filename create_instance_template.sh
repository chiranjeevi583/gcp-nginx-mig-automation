#!/bin/bash

gcloud compute instance-templates create nginx-template \
--metadata=startup-script='#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx' \
--machine-type=e2-medium \
--region=us-central1

