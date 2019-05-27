#!/bin/sh

if [ -z "$VAULT_HOST" ]; then
	echo 'NO $VAULT_HOST'
	exit 1
fi

if [ -z "$JSONFILE" ]; then
	echo 'NO $JSONFILE'
	exit 1
fi

echo $val

export VAULT_ADDR="http://${VAULT_HOST}"

echo $VAULT_ADDR

export SHARES=3
export THRESHOLD=2
export TOKEN=`cat $JSONFILE | jq ".root_token" -r`

echo $SHARES
echo $THRESHOLD

for i in `seq $THRESHOLD`
do
	export KEY=`cat $JSONFILE | jq ".keys[$i]" -r`
	echo $KEY
	vault operator unseal $KEY
done

echo "Enabling Enterprise"

curl \
    --header "X-Vault-Token: $TOKEN" \
    --request PUT \
    --data @license.json \
    $VAULT_ADDR/v1/sys/license