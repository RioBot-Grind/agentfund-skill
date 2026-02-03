#!/bin/bash
# AgentFund - Create Fundraise Proposal
# Usage: ./create-proposal.sh <agent-address> <milestone1-eth> [milestone2-eth] ...

CONTRACT="0x6a4420f696c9ba6997f41dddc15b938b54aa009a"

if [ $# -lt 2 ]; then
    echo "Usage: $0 <agent-address> <milestone1-eth> [milestone2-eth] ..."
    echo "Example: $0 0xYourAddress 0.01 0.02 0.01"
    exit 1
fi

AGENT=$1
shift
MILESTONES=("$@")

# Calculate total
TOTAL=0
for amt in "${MILESTONES[@]}"; do
    TOTAL=$(echo "$TOTAL + $amt" | bc)
done

echo "🚀 AgentFund Fundraise Proposal"
echo "================================"
echo ""
echo "Agent (you): $AGENT"
echo "Total Funding: $TOTAL ETH"
echo "Milestones: ${#MILESTONES[@]}"
echo ""
echo "Milestone Breakdown:"
for i in "${!MILESTONES[@]}"; do
    echo "  $((i+1)). ${MILESTONES[$i]} ETH"
done
echo ""
echo "📋 For Funder to Execute:"
echo "  Contract: $CONTRACT"
echo "  Value: $TOTAL ETH"
echo "  Function: createProject(address agent, uint256[] milestoneAmounts)"
echo ""
echo "Share this proposal with potential funders!"
echo "BaseScan: https://basescan.org/address/$CONTRACT#writeContract"
