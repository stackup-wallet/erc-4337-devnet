#!/bin/bash

NODE_URL="http://localhost:8545"
JSONRPC_REQUEST='{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "eth_getCode",
    "params": ["0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789", "latest"]
}'

while true; do
    RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" --data "$JSONRPC_REQUEST" "$NODE_URL")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to connect to the blockchain node. Retrying in 3 seconds..."
        sleep 3
        continue
    fi

    CODE_HEX=$(echo "$RESPONSE" | jq -r '.result')
    if [ $CODE_HEX != "0x" ]; then
        echo "ERC-4337 Devnet is ready."
        break  # Exit the loop once the condition is met.
    else
        echo "ERC-4337 Devnet is not ready. Checking again soon..."
        sleep 3
    fi
done
