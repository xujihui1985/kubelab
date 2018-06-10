#!/bin/bash

gcloud -q compute instances delete \
    controller-0 controller-1 controller-2 \
	worker-0 worker-1 worker-2