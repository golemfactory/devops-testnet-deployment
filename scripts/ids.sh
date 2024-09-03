#! /bin/bash

for i in $(seq 1 25); do echo host$i; docker exec testnet1-provider$i-1 yagna id show; done


