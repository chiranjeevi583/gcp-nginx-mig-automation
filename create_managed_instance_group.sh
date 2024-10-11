#!/bin/bash

gcloud compute instance-groups managed create nginx-group \
--base-instance-name nginx \
--template=nginx-template \
--size=3 \
--zone=us-central1-c

