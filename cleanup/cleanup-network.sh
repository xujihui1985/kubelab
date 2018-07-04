#!/bin/bash

gcloud -q compute forwarding-rules delete kubernetes-forwarding-rule \
      --region $(gcloud config get-value compute/region)

