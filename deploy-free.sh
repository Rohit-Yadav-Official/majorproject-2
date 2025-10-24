#!/bin/bash

# 🚀 FREE Deployment Script for Carbon Tax System
# This script automates the deployment process for free hosting services

echo "🚀 Starting FREE deployment of Carbon Tax System..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if required tools are installed
check_requirements() {
    print_info "Checking requirements..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    if ! command -v java &> /dev/null; then
        print_error "Java is not installed. Please install Java 17 first."
        exit 1
    fi
    
    print_status "All requirements satisfied!"
}

# Deploy smart contracts to Sepolia testnet
deploy_contracts() {
    print_info "Deploying smart contracts to Sepolia testnet..."
    
    cd contracts
    
    # Check if .env file exists
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from example..."
        cp .env.example .env
        print_warning "Please edit .env file with your credentials before continuing."
        print_warning "Required: INFURA_PROJECT_ID, PRIVATE_KEY, ETHERSCAN_API_KEY"
        return 1
    fi
    
    # Install dependencies
    print_info "Installing contract dependencies..."
    npm install
    
    # Deploy to Sepolia
    print_info "Deploying to Sepolia testnet..."
    npm run deploy:testnet
    
    if [ $? -eq 0 ]; then
        print_status "Smart contracts deployed successfully!"
        print_info "Copy the contract address from the output above."
    else
        print_error "Contract deployment failed!"
        return 1
    fi
    
    cd ..
}

# Prepare backend for deployment
prepare_backend() {
    print_info "Preparing backend for deployment..."
    
    cd "major back"
    
    # Create production properties if not exists
    if [ ! -f "src/main/resources/application-production.properties" ]; then
        print_warning "Production properties file not found. Please create it manually."
    fi
    
    # Build the application
    print_info "Building Spring Boot application..."
    ./mvnw clean package -DskipTests
    
    if [ $? -eq 0 ]; then
        print_status "Backend build successful!"
    else
        print_error "Backend build failed!"
        return 1
    fi
    
    cd ..
}

# Prepare frontend for deployment
prepare_frontend() {
    print_info "Preparing frontend for deployment..."
    
    cd "major front"
    
    # Install dependencies
    print_info "Installing frontend dependencies..."
    npm install
    
    # Build the application
    print_info "Building React application..."
    npm run build
    
    if [ $? -eq 0 ]; then
        print_status "Frontend build successful!"
    else
        print_error "Frontend build failed!"
        return 1
    fi
    
    cd ..
}

# Main deployment function
main() {
    echo "🎯 Carbon Tax System - FREE Deployment"
    echo "======================================"
    echo ""
    echo "This script will help you deploy your carbon tax system for FREE using:"
    echo "• Smart Contracts: Sepolia Testnet (Free)"
    echo "• Backend: Railway/Render (Free tier)"
    echo "• Frontend: Vercel/Netlify (Free tier)"
    echo "• Database: Railway PostgreSQL (Free tier)"
    echo ""
    
    # Check requirements
    check_requirements
    
    # Ask user what they want to deploy
    echo "What would you like to deploy?"
    echo "1) Smart Contracts only"
    echo "2) Backend only"
    echo "3) Frontend only"
    echo "4) Everything (Full deployment)"
    echo "5) Exit"
    
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            deploy_contracts
            ;;
        2)
            prepare_backend
            print_info "Backend ready for deployment to Railway/Render!"
            print_info "Next steps:"
            print_info "1. Push code to GitHub"
            print_info "2. Connect to Railway/Render"
            print_info "3. Set environment variables"
            ;;
        3)
            prepare_frontend
            print_info "Frontend ready for deployment to Vercel/Netlify!"
            print_info "Next steps:"
            print_info "1. Push code to GitHub"
            print_info "2. Connect to Vercel/Netlify"
            print_info "3. Update contract configuration"
            ;;
        4)
            deploy_contracts
            if [ $? -eq 0 ]; then
                prepare_backend
                prepare_frontend
                print_status "All components ready for deployment!"
                print_info "Next steps:"
                print_info "1. Push code to GitHub"
                print_info "2. Deploy backend to Railway/Render"
                print_info "3. Deploy frontend to Vercel/Netlify"
                print_info "4. Configure environment variables"
                print_info "5. Test your deployment"
            fi
            ;;
        5)
            print_info "Exiting deployment script..."
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
    
    echo ""
    print_status "Deployment preparation complete!"
    print_info "For detailed deployment instructions, see DEPLOYMENT_GUIDE.md"
}

# Run main function
main
