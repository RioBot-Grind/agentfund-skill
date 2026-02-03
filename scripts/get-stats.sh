#!/bin/bash
# Get AgentFund platform statistics
# Usage: bash get-stats.sh

CONTRACT="0x6a4420f696c9ba6997f41dddc15b938b54aa009a"
RPC="https://mainnet.base.org"

echo "📊 AgentFund Platform Stats"
echo "==========================="
echo ""

# Get total projects (projectCount)
TOTAL=$(curl -s "$RPC" -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'"$CONTRACT"'","data":"0x6ada7847"},"latest"],"id":1}' \
    | jq -r '.result' | xargs printf "%d\n" 2>/dev/null)

echo "Total Projects: $TOTAL"

# Get platform fee (platformFeePercent)
FEE=$(curl -s "$RPC" -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'"$CONTRACT"'","data":"0x5a2bcc18"},"latest"],"id":1}' \
    | jq -r '.result' | xargs printf "%d\n" 2>/dev/null)

echo "Platform Fee: ${FEE}%"
echo ""
echo "Contract: $CONTRACT"
echo "Chain: Base Mainnet"
echo "BaseScan: https://basescan.org/address/$CONTRACT"
