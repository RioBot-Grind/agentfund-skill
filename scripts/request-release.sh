#!/bin/bash
# Generate milestone release request for funder
# Usage: bash request-release.sh <project-id> <milestone-index>

CONTRACT="0x6a4420f696c9ba6997f41dddc15b938b54aa009a"
RPC="https://mainnet.base.org"

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: bash request-release.sh <project-id> <milestone-index>"
    echo "Example: bash request-release.sh 0 0  # Release first milestone of project 0"
    exit 1
fi

PROJECT_ID=$1
MILESTONE=$2

# Get project details first
ID_HEX=$(printf "%064x" $PROJECT_ID)
DATA="0x7b0472f0${ID_HEX}"

RESULT=$(curl -s "$RPC" -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'"$CONTRACT"'","data":"'"$DATA"'"},"latest"],"id":1}' \
    | jq -r '.result')

if [ "$RESULT" = "0x" ] || [ -z "$RESULT" ]; then
    echo "❌ Project #$PROJECT_ID not found"
    exit 1
fi

AGENT="0x${RESULT:26:40}"
FUNDER="0x${RESULT:90:40}"

echo "📤 Milestone Release Request"
echo "============================="
echo ""
echo "Project ID: $PROJECT_ID"
echo "Milestone: $MILESTONE"
echo "Agent: $AGENT"
echo "Funder: $FUNDER"
echo ""
echo "Contract: $CONTRACT"
echo "Function: releaseMilestone(uint256 projectId, uint256 milestoneIndex)"
echo ""
echo "📋 Send to funder:"
echo "---"
echo "To release milestone $MILESTONE for project #$PROJECT_ID:"
echo ""
echo "Call releaseMilestone($PROJECT_ID, $MILESTONE) on:"
echo "https://basescan.org/address/$CONTRACT#writeContract"
echo ""
echo "Or use cast:"
echo "cast send $CONTRACT 'releaseMilestone(uint256,uint256)' $PROJECT_ID $MILESTONE --rpc-url $RPC"
echo "---"
