#!/bin/sh
while true; do
    echo "Starting script.py at $(date)"
    python3 /usr/src/app/script.py --payment-driver=erc20 --payment-network=polygon
    sleep 3600
done
