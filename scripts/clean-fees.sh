#! /bin/bash

#for i in $(seq 1 10); do echo host$i; docker compose exec --index $i provider yagna id show; done
for i in $(seq 1 25); do echo host$i; docker exec testnet1-provider$i-1 golemsp settings set --starting-fee 0 --env-per-hour 0 --cpu-per-hour 0;  done


