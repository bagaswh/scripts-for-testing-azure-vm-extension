wget -q $base_url/assets/az-pipelines-agent/deploy.sh -O az-pipelines-agent-deploy.sh

cp az-pipelines-agent-deploy.sh /home/azureuser/deploy.sh
chown azureuser:azureuser /home/azureuser/deploy.sh
chmod +x /home/azureuser/deploy.sh
