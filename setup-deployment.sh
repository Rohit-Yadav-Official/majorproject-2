#!/bin/bash

# 🚀 Carbon Tax System - Deployment Setup Script
# This script helps you set up the required free accounts and credentials

echo "🚀 Carbon Tax System - FREE Deployment Setup"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

echo "📋 Required FREE Accounts:"
echo "1. Infura (for blockchain access)"
echo "2. MetaMask (for test wallet)"
echo "3. Etherscan (for contract verification)"
echo "4. Railway (for backend hosting)"
echo "5. Vercel (for frontend hosting)"
echo ""

print_info "Let's set up your deployment step by step..."
echo ""

# Step 1: Infura Setup
echo "🔗 Step 1: Infura Setup (FREE)"
echo "=============================="
echo "1. Go to: https://infura.io/"
echo "2. Sign up for free account"
echo "3. Create new project"
echo "4. Copy your Project ID"
echo ""
read -p "Enter your Infura Project ID: " INFURA_PROJECT_ID

if [ -z "$INFURA_PROJECT_ID" ]; then
    print_error "Infura Project ID is required!"
    exit 1
fi

# Step 2: Test Wallet Setup
echo ""
echo "🔗 Step 2: Test Wallet Setup (FREE)"
echo "===================================="
echo "1. Install MetaMask browser extension"
echo "2. Create NEW test wallet (never use real funds)"
echo "3. Copy private key"
echo ""
read -p "Enter your test wallet private key: " PRIVATE_KEY

if [ -z "$PRIVATE_KEY" ]; then
    print_error "Private key is required!"
    exit 1
fi

# Step 3: Etherscan API Key
echo ""
echo "🔗 Step 3: Etherscan API Key (FREE)"
echo "===================================="
echo "1. Go to: https://etherscan.io/apis"
echo "2. Sign up for free account"
echo "3. Generate API key"
echo ""
read -p "Enter your Etherscan API key: " ETHERSCAN_API_KEY

if [ -z "$ETHERSCAN_API_KEY" ]; then
    print_error "Etherscan API key is required!"
    exit 1
fi

# Update .env file
print_info "Updating .env file with your credentials..."

cat > .env << EOF
# Carbon Tax System - Production Configuration
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/$INFURA_PROJECT_ID
PRIVATE_KEY=$PRIVATE_KEY
ETHERSCAN_API_KEY=$ETHERSCAN_API_KEY

# Gas and performance settings
REPORT_GAS=true

# College Project Settings
PROJECT_NAME="Carbon Tax Blockchain System"
DEMO_MODE=true
INITIAL_TOKEN_SUPPLY=1000000
MIN_VALIDATOR_STAKE=1000
CARBON_TAX_RATE=5
EOF

print_status ".env file updated successfully!"

# Deploy smart contracts
echo ""
print_info "Deploying smart contracts to Sepolia testnet..."

# Install dependencies
print_info "Installing dependencies..."
npm install

# Deploy to Sepolia
print_info "Deploying to Sepolia testnet (this may take a few minutes)..."
npm run deploy:testnet

if [ $? -eq 0 ]; then
    print_status "Smart contracts deployed successfully!"
    echo ""
    print_info "Next steps:"
    echo "1. Copy the contract address from the output above"
    echo "2. Deploy backend to Railway"
    echo "3. Deploy frontend to Vercel"
    echo "4. Update contract configuration"
    echo ""
    print_info "Your smart contracts are now live on Sepolia testnet!"
    print_info "You can view them at: https://sepolia.etherscan.io/"
else
    print_error "Smart contract deployment failed!"
    print_info "Please check your credentials and try again."
    exit 1
fi

echo ""
print_status "Setup complete! Your carbon tax system is ready for deployment."
print_info "Run './deploy-free.sh' to continue with backend and frontend deployment."
