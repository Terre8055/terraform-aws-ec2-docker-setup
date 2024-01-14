#!/bin/bash

terraform init
sleep 2
terraform plan
sleep 2
terraform apply -auto-approve
sleep 5
