#!/bin/bash

get_addr() {
    local _if_name=$1
    /sbin/ifconfig "${_if_name}" | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'
}
if [ -n "${VAULT_LOCAL_CONFIG}" ]; then
    export VAULT_ADDR=127.0.0.1
else
    export VAULT_ADDR=$(get_addr $VAULT_INTERFACE)
fi
export VAULT_ADDR_FLAG="-address=http://${VAULT_ADDR}:8200"
echo "Using $VAULT_INTERFACE for VAULT_ADDR: $VAULT_ADDR"

sleep 10

secrets=$(mktemp)
trap "rm -rf ${secrets}" EXIT

init_results=$(vault init "${VAULT_ADDR_FLAG}" | grep ':' > "${secrets}")
keys=$(cat "${secrets}" | grep "^Unseal Key" | awk "{print \$4}")
vault_root_token=$(cat "${secrets}" | grep "^Initial Root Token:" | awk "{print \$4}")

for key in $keys
do
    vault unseal "${VAULT_ADDR_FLAG}" $key
done

# initial login to bootstrap other permissions
vault auth "${VAULT_ADDR_FLAG}" "${vault_root_token}"

# create generic admin policies
vault policy-write "${VAULT_ADDR_FLAG}" admin /vault/policies/admin.hcl

# setup ldap
vault auth-enable "${VAULT_ADDR_FLAG}" ldap
vault write "${VAULT_ADDR_FLAG}" auth/ldap/config \
    url="ldaps://${LDAP_SERVER}:636" \
    starttls=true \
    insecure_tls=true \
    userdn="ou=Accounts,o=${DOMAIN}" \
    userattr="uid" \
    groupdn="ou=groups,o=${DOMAIN}"

# grant root-like policy to the admin team
vault write "${VAULT_ADDR_FLAG}" auth/ldap/groups/it policies=admin

# revoke the default root token
vault token-revoke "${VAULT_ADDR_FLAG}" "${vault_root_token}"

exit 0
