# ⚡ Quick FREE Deployment Guide

## 🎯 One-Click Deployment (5 Minutes)

### Step 1: Get Free Accounts (2 minutes)
1. **Infura**: [infura.io](https://infura.io/) → Create project → Copy Project ID
2. **MetaMask**: [metamask.io](https://metamask.io/) → Create test wallet → Copy private key
3. **Railway**: [railway.app](https://railway.app/) → Sign up with GitHub
4. **Vercel**: [vercel.com](https://vercel.com/) → Sign up with GitHub

### Step 2: Deploy Smart Contracts (1 minute)
```bash
cd contracts
cp .env.example .env
# Edit .env with your credentials
npm install
npm run deploy:testnet
# Copy the contract address!
```

### Step 3: Deploy Backend (1 minute)
1. Push code to GitHub
2. Go to Railway → New Project → Connect GitHub
3. Select `major back` folder
4. Add environment variables:
   - `DATABASE_URL` (auto-generated)
   - `BLOCKCHAIN_CONTRACT_ADDRESS` (from step 2)
   - `BLOCKCHAIN_RPC_URL` (your Infura URL)
   - `BLOCKCHAIN_PRIVATE_KEY` (your test wallet key)

### Step 4: Deploy Frontend (1 minute)
1. Go to Vercel → Import Project → Connect GitHub
2. Select `major front` folder
3. Update `src/contracts/contract-config.json` with your contract address
4. Deploy!

## 🎉 You're Live!

**Your URLs:**
- Frontend: `https://your-app.vercel.app`
- Backend: `https://your-api.railway.app`
- Smart Contract: `https://sepolia.etherscan.io/address/YOUR_CONTRACT`

## 🧪 Test Your Deployment
1. Open frontend URL
2. Connect MetaMask to Sepolia testnet
3. Try purchasing a product
4. Check transaction on Etherscan

## 📞 Need Help?
- See `DEPLOYMENT_GUIDE.md` for detailed instructions
- Run `./deploy-free.sh` for automated deployment
- Check logs in Railway/Vercel dashboards

**Total Cost: $0.00** 🎉
