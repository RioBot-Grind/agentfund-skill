#!/bin/bash
# Find projects where you're the agent (beneficiary)
# Usage: bash find-my-projects.sh <your-wallet-address>

CONTRACT="0x6a4420f696c9ba6997f41dddc15b938b54aa009a"
RPC="https://mainnet.base.org"

if [ -z "$1" ]; then
    echo "Usage: bash find-my-projects.sh <your-wallet-address>"
    exit 1
fi

WALLET=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Get total project count
TOTAL=$(curl -s "$RPC" -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'"$CONTRACT"'","data":"0x6ada7847"},"latest"],"id":1}' \
    | jq -r '.result' | xargs printf "%d\n" 2>/dev/null)

echo "Scanning $TOTAL projects for wallet $WALLET..."
echo ""

FOUND=0
for i in $(seq 0 $((TOTAL-1))); do
    # Encode project ID (uint256)
    ID_HEX=$(printf "%064x" $i)
    
    # getProject(uint256) = 0x6ada7847
    DATA="0x7b0472f0${ID_HEX}"
    
    RESULT=$(curl -s "$RPC" -X POST \
        -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'"$CONTRACT"'","data":"'"$DATA"'"},"latest"],"id":1}' \
        | jq -r '.result')
    
    # Extract agent address (first 32 bytes after removing 0x)
    AGENT="0x${RESULT:26:40}"
    AGENT_LOWER=$(echo "$AGENT" | tr '[:upper:]' '[:lower:]')
    
    if [ "$AGENT_LOWER" = "$WALLET" ]; then
        FOUND=$((FOUND+1))
        # Parse more details
        FUNDER="0x${RESULT:90:40}"
        echo "📦 Project #$i"
        echo "   Agent: $AGENT"
        echo "   Funder: $FUNDER"
        echo ""
    fi
done

if [ $FOUND -eq 0 ]; then
    echo "No projects found for $WALLET"
else
    echo "Found $FOUND project(s)"
fi
