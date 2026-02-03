#!/bin/bash
# Generate funding transaction for a project
# Usage: bash fund-project.sh <project-id> <amount-eth>

CONTRACT="0x6a4420f696c9ba6997f41dddc15b938b54aa009a"
RPC="https://mainnet.base.org"

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: bash fund-project.sh <project-id> <amount-eth>"
    echo "Example: bash fund-project.sh 0 0.1"
    exit 1
fi

PROJECT_ID=$1
AMOUNT_ETH=$2

# Convert ETH to wei
AMOUNT_WEI=$(echo "$AMOUNT_ETH * 1000000000000000000" | bc | cut -d'.' -f1)

# Encode fundProject(uint256)
ID_HEX=$(printf "%064x" $PROJECT_ID)
DATA="0xed6c984b${ID_HEX}"

echo "💰 Fund Project Transaction"
echo "============================"
echo ""
echo "Project ID: $PROJECT_ID"
echo "Amount: $AMOUNT_ETH ETH ($AMOUNT_WEI wei)"
echo ""
echo "📋 Transaction Details:"
echo "To: $CONTRACT"
echo "Value: $AMOUNT_ETH ETH"
echo "Data: $DATA"
echo ""
echo "🔗 Fund via BaseScan:"
echo "https://basescan.org/address/$CONTRACT#writeContract"
echo ""
echo "Or use cast:"
echo "cast send $CONTRACT 'fundProject(uint256)' $PROJECT_ID --value ${AMOUNT_ETH}ether --rpc-url $RPC"
