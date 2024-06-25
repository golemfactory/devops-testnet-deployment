instances=25
subnet="public"
version="0.15.2"


def service(idx):
    port = 11500 + idx
    api_port = 7400 + idx
    return f'''  provider{idx}:
    image: golemfactory/provider:{version}
    network_mode: "host"
    privileged: true
    command: [ "golemsp", "run", "--no-interactive" ]
    stdin_open: true
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 5G
          cpus: "3.0"
    volumes:
      - /root/.local/share/ya-provider
      - /root/.local/share/yagna
    environment:
      NODE_NAME: "testnet-c1-{idx}"
      YA_PAYMENT_NETWORK_GROUP: testnet
      YA_ACCOUNT: "0x206bfe4F439a83b65A5B9c2C3B1cc6cB49054cc4"
      YA_NET_BIND_URL: udp://0.0.0.0:{port}
      YAGNA_API_URL: http://127.0.0.1:{api_port}
      AUTO_CLEANUP_ACTIVITY: true
      AUTO_CLEANUP_AGREEMENT: true
      YA_RT_MEM: 4.5
      SUBNET: {subnet}
'''


with open('docker-compose.yaml', 'wt') as f:
    f.write("services:\n")

    for idx in range(instances):
        f.write(service(idx))

