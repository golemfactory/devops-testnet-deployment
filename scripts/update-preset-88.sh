#! /bin/bash

for i in $(seq 1 25)
 do echo host$i
docker exec devops-testnet-deployment-provider$i-1 ya-provider profile update --name default --cpu-threads 8 --mem-gib 8
 done


