#!/bin/bash

get_addr() {
    local _if_name=$1
    /sbin/ifconfig "${_if_name}" | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'
}

export VAULT_ADDR=$(get_addr $VAULT_INTERFACE)
echo "Using ${VAULT_INTERFACE} for VAULT_ADDR: ${VAULT_ADDR}"

if [ -n "${VAULT_REDIRECT_INTERFACE}" ]; then
    export VAULT_REDIRECT_ADDR="http://${VAULT_ADDR}:8200"
    echo "Using ${VAULT_REDIRECT_INTERFACE} for VAULT_REDIRECT_ADDR: ${VAULT_REDIRECT_ADDR}"
fi
if [ -n "${VAULT_CLUSTER_INTERFACE}" ]; then
    export VAULT_CLUSTER_ADDR="https://${VAULT_ADDR}:8201"
    echo "Using ${VAULT_CLUSTER_INTERFACE} for VAULT_CLUSTER_ADDR: ${VAULT_CLUSTER_ADDR}"
fi

if [ -n "${VAULT_LOCAL_CONFIG}" ]; then
    echo "${VAULT_LOCAL_CONFIG}" > "${VAULT_CONFIG_DIR}/local.json"
else
    /usr/local/bin/confd -onetime -backend "${CONFD_BACKEND}"
fi

if [ "$(stat -c %u /vault/config)" != "$(id -u phillipfry)" ]; then
    chown -R phillipfry:phillipfry /vault/config || echo "Could not chown /vault/config (may not have appropriate permissions)"
fi

if [ "$(stat -c %u /vault/logs)" != "$(id -u phillipfry)" ]; then
    chown -R phillipfry:phillipfry /vault/logs
fi

if [ "$(stat -c %u /vault/file)" != "$(id -u phillipfry)" ]; then
    chown -R phillipfry:phillipfry /vault/file
fi

if [ -z "${SKIP_SETCAP}" ]; then
    setcap cap_ipc_lock=+ep $(readlink -f $(which vault))

    if ! vault -version 1>/dev/null 2>/dev/null; then
        >&2 echo "Couldn't start vault with IPC_LOCK. Disabling IPC_LOCK, please use --privileged or --cap-add IPC_LOCK"
        setcap cap_ipc_lock=-ep $(readlink -f $(which vault))
    fi
fi

gosu phillipfry:phillipfry vault server -config="${VAULT_CONFIG_DIR}"
