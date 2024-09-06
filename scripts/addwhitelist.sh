#! /bin/bash

for i in $(seq 1 25); do echo host$i; docker exec devops-testnet-deployment-provider$i-1 ya-provider whitelist add -p 69.55.231.8; done


