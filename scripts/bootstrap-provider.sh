#! /bin/bash

cd /home/ubuntu
git clone https://github.com/golemfactory/devops-testnet-deployment.git
cd /home/ubuntu/devops-testnet-deployment
sudo apt-get update
sudo apt-get upgrade -y

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install dependancies :
sudo apt install python3 python-is-python3 mc -y

# Install the latest Docker version :
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add user to Docker group :
sudo usermod -aG docker ubuntu

# Create golem-compose creator (Python):

cat << 'EOF' > create_docker_compose.py
instances=3
subnet="public"
version="0.16.0-rc4"
memory="2G"
cpus="1.0"
providername="ethwarsaw1-sameasinstance"

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
          memory: {memory}
          cpus: "{cpus}"
    volumes:
      - /root/.local/share/ya-provider
      - /root/.local/share/yagna
    environment:
      NODE_NAME: "testnet-c1-{providername}-{idx}"
      YA_NET_PUB_BROADCAST_SIZE: 150
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
EOF

# Add  perms to creator :
chmod +x create_docker_compose.py

# Creat docker compose file :
python3 create_docker_compose.py

# Start Golem :
sudo docker compose up -d


