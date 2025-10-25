# 🚂 Railway Setup Guide

## 🎯 **Current Issue: Whole Folder Deployed**

Since you deployed the entire folder, Railway doesn't know which part is your backend. Here's how to fix it:

## 🔧 **Solution 1: Configure Railway Settings**

### Step 1: Update Railway Project Settings
1. Go to your Railway dashboard
2. Click on your project
3. Go to **Settings → Deploy**
4. Set these values:
   - **Root Directory**: `major back`
   - **Build Command**: `./mvnw clean package -DskipTests`
   - **Start Command**: `java -jar target/api-0.0.1-SNAPSHOT.jar`

### Step 2: Add Environment Variables
In Railway dashboard, go to **Variables** and add:
```
DATABASE_URL=postgresql://username:password@host:port/database
BLOCKCHAIN_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID
BLOCKCHAIN_CONTRACT_ADDRESS=YOUR_DEPLOYED_CONTRACT_ADDRESS
BLOCKCHAIN_PRIVATE_KEY=YOUR_TEST_WALLET_PRIVATE_KEY
BLOCKCHAIN_CHAIN_ID=11155111
```

## 🔧 **Solution 2: Create Separate Services (Recommended)**

### Step 1: Create Database Service
1. In Railway dashboard, click **+ New**
2. Select **Database → PostgreSQL**
3. This will create a free PostgreSQL database
4. Copy the connection string

### Step 2: Create Backend Service
1. Click **+ New → GitHub Repo**
2. Select your repository
3. Set **Root Directory** to `major back`
4. Railway will auto-detect Spring Boot
5. Add environment variables from Step 2 above

## 🔧 **Solution 3: Use Railway Configuration File**

I've created `major back/railway.json` with the correct configuration. Push this to GitHub:

```bash
git add .
git commit -m "Add Railway configuration for backend"
git push origin main
```

## 🧪 **Test Your Backend**

Once configured, test your backend:

1. **Health Check**: `https://your-app.railway.app/api/health`
2. **Blockchain Status**: `https://your-app.railway.app/api/blockchain/status`
3. **Products API**: `https://your-app.railway.app/api/products`

## 📊 **Expected Results**

Your backend should show:
- ✅ Spring Boot application running
- ✅ Database connection established
- ✅ Blockchain connection active
- ✅ API endpoints responding

## 🆘 **Troubleshooting**

### Common Issues:
1. **"Build failed"** → Check Root Directory is set to `major back`
2. **"Database connection failed"** → Add DATABASE_URL environment variable
3. **"Blockchain connection failed"** → Add blockchain environment variables
4. **"Port binding failed"** → Railway auto-assigns port, check logs

### Check Logs:
1. Go to Railway dashboard
2. Click on your service
3. Go to **Deployments** tab
4. Click on latest deployment
5. Check **Build Logs** and **Deploy Logs**

## 🎯 **Next Steps**

After backend is working:
1. Deploy frontend to Vercel
2. Update frontend contract configuration
3. Test full application
4. Configure custom domain (optional)

---

**Need help?** Check Railway logs and let me know what errors you see!
