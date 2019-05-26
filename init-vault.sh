#!/bin/sh

export FILENAME=$1
export VAULT_HOST=vault.kabuctl.run
export VAULT_ADDR="http://${VAULT_HOST}"

echo $VAULT_ADDR

vault operator init -format=json > $FILENAME
export SHARES=`cat vault-keys.json | jq '.unseal_shares' -r`
export THRESHOLD=`cat vault-keys.json | jq '.unseal_threshold' -r`
export TOKEN=`cat vault-keys.json | jq ".root_token" -r`

echo $SHARES
echo $THRESHOLD

for i in `seq $THRESHOLD`
do
	export KEY=`cat $FILENAME | jq ".unseal_keys_b64[$i]" -r`
	echo $KEY
	vault operator unseal $KEY
done

echo "Enabling Enterprise"

curl \
    --header "X-Vault-Token: $TOKEN" \
    --request PUT \
    --data @license.json \
    $VAULT_ADDR/v1/sys/license