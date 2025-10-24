const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment to Sepolia testnet...");
  
  // Get the contract factory
  const CarbonTaxSystem = await ethers.getContractFactory("CarbonTaxSystem");
  
  // Deploy the contract
  console.log("📦 Deploying CarbonTaxSystem contract...");
  const carbonTaxSystem = await CarbonTaxSystem.deploy();
  
  // Wait for deployment to complete
  await carbonTaxSystem.waitForDeployment();
  
  const contractAddress = await carbonTaxSystem.getAddress();
  console.log("✅ CarbonTaxSystem deployed to:", contractAddress);
  
  // Get deployment transaction details
  const deploymentTx = carbonTaxSystem.deploymentTransaction();
  console.log("📋 Deployment transaction hash:", deploymentTx?.hash);
  
  // Verify contract on Etherscan (optional)
  try {
    console.log("🔍 Verifying contract on Etherscan...");
    await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments: [],
    });
    console.log("✅ Contract verified on Etherscan!");
  } catch (error) {
    console.log("⚠️ Contract verification failed (this is normal for testnet):", error.message);
  }
  
  // Display important information
  console.log("\n🎉 Deployment successful!");
  console.log("📊 Contract Details:");
  console.log("   Address:", contractAddress);
  console.log("   Network: Sepolia Testnet");
  console.log("   Explorer: https://sepolia.etherscan.io/address/" + contractAddress);
  console.log("\n📝 Next Steps:");
  console.log("   1. Copy the contract address above");
  console.log("   2. Update your backend configuration");
  console.log("   3. Update your frontend contract-config.json");
  console.log("   4. Test the deployment with your application");
  
  // Save deployment info to file
  const deploymentInfo = {
    contractAddress: contractAddress,
    network: "sepolia",
    deploymentTx: deploymentTx?.hash,
    timestamp: new Date().toISOString(),
    explorer: `https://sepolia.etherscan.io/address/${contractAddress}`
  };
  
  require('fs').writeFileSync(
    './deployments/sepolia-deployment.json', 
    JSON.stringify(deploymentInfo, null, 2)
  );
  
  console.log("💾 Deployment info saved to deployments/sepolia-deployment.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
