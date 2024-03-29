#!/bin/bash

PROXY_URL="http://localhost:8545"
BUNDLER_REQ='{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "eth_supportedEntryPoints",
    "params": []
}'

while true; do
    BUNDLER_RESP=$(curl -s -X POST -H "Content-Type: application/json" --data "$BUNDLER_REQ" "$PROXY_URL")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to make bundler request. Retrying in 3 seconds..."
        sleep 3
        continue
    elif ! echo $BUNDLER_RESP | jq . > /dev/null 2>&1; then
        echo "Error: Bundler response is not valid JSON. Retrying in 3 seconds..."
        sleep 3
        continue
    fi

    READY=false
    SUPPORTED_ENTRYPOINTS=()
    while IFS= read -r line; do
        SUPPORTED_ENTRYPOINTS+=("$line")
    done < <(echo "$BUNDLER_RESP" | jq -r '.result[]')
    for ENTRYPOINT in "${SUPPORTED_ENTRYPOINTS[@]}"; do
        NODE_REQ="{
            \"jsonrpc\": \"2.0\",
            \"id\": 1,
            \"method\": \"eth_getCode\",
            \"params\": [\"$ENTRYPOINT\", \"latest\"]
        }"
        NODE_RESP=$(curl -s -X POST -H "Content-Type: application/json" --data "$NODE_REQ" "$PROXY_URL")
        if [ $? -ne 0 ]; then
            echo "Error: Failed to make node request. Retrying in 3 seconds..."
            break
        fi


        CODE_HEX=$(echo "$NODE_RESP" | jq -r '.result')
        if [ $CODE_HEX != "0x" ]; then
            echo "ERC-4337 Devnet is ready."
            READY=true
        else
            echo "ERC-4337 Devnet is not ready. Checking again soon..."
            READY=false
        fi
    done

    if [ "$READY" == "true" ]; then
        exit 0;
    fi
    sleep 3
done
