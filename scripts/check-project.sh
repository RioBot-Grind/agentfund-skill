#!/bin/bash
# AgentFund - Check Project Status
# Usage: ./check-project.sh <project-id>

CONTRACT="0x6a4420f696c9ba6997f41dddc15b938b54aa009a"
RPC="https://mainnet.base.org"

if [ -z "$1" ]; then
    echo "Usage: $0 <project-id>"
    exit 1
fi

PROJECT_ID=$1

# Encode function call: getProject(uint256)
# Function selector: 0xf0f44260
PADDED_ID=$(printf "%064x" $PROJECT_ID)
DATA="0xf0f44260${PADDED_ID}"

RESULT=$(curl -s "$RPC" -X POST \
  -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_call\",\"params\":[{\"to\":\"$CONTRACT\",\"data\":\"$DATA\"},\"latest\"],\"id\":1}" | jq -r '.result')

if [ "$RESULT" == "null" ] || [ -z "$RESULT" ]; then
    echo "Error fetching project"
    exit 1
fi

echo "📊 Project #$PROJECT_ID Status"
echo "=============================="
echo "Raw data: $RESULT"
echo ""
echo "View on BaseScan:"
echo "https://basescan.org/address/$CONTRACT#readContract"
