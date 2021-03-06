#!/bin/sh

wget https://raw.githubusercontent.com/tkaburagi/vault-configs/master/remote-vault-template.hcl
wget https://raw.githubusercontent.com/tkaburagi/consul-configs/master/consul-server-cluster-template.json
sed -e 's/SERVER_NUM_REPLACE/${var.vault_instance_count}/g' consul-server-cluster-template.json > consul-server-cluster.json
sed -e 's/SERVICE_NAME_REPLACE/"${var.vault_instance_name}-${count.index}-hashistack"/g' remote-vault-template.hcl > remote-vault-template-2.hcl
sed -e 's/API_ADDR_REPLACE/"http:\/\/${aws_alb.vault_alb.dns_name}"/g' remote-vault-template-2.hcl > remote-vault-template-3.hcl
sed -e 's/CLUSTER_ADDR_REPLACE/"https:\/\/${}:8201"/g' remote-vault-template-3.hcl > remote-vault.hcl
