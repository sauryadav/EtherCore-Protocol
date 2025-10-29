// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  console.log("🚀 Starting EtherCore Protocol deployment...\n");

  // Get the contract factory
  const Project = await hre.ethers.getContractFactory("Project");
  
  console.log("📝 Deploying Project contract...");
  
  // Deploy the contract
  const project = await Project.deploy();
  
  // Wait for deployment to complete
  await project.deployed();
  
  console.log("✅ Project contract deployed successfully!");
  console.log("📍 Contract Address:", project.address);
  console.log("👤 Deployer Address:", (await hre.ethers.getSigners())[0].address);
  
  // Get deployment transaction details
  const deployTx = project.deployTransaction;
  console.log("🔗 Transaction Hash:", deployTx.hash);
  console.log("⛽ Gas Used:", deployTx.gasLimit.toString());
  
  console.log("\n📊 Contract Information:");
  console.log("========================");
  console.log("Owner:", await project.owner());
  console.log("Total Deposits:", (await project.totalDeposits()).toString());
  console.log("Contract Balance:", (await project.contractBalance()).toString());
  
  console.log("\n✨ Deployment complete!");
  console.log("You can now interact with the contract at:", project.address);
  
  // Save deployment info to a file
  const fs = require('fs');
  const deploymentInfo = {
    network: hre.network.name,
    contractAddress: project.address,
    deployer: (await hre.ethers.getSigners())[0].address,
    transactionHash: deployTx.hash,
    timestamp: new Date().toISOString()
  };
  
  fs.writeFileSync(
    'deployment-info.json',
    JSON.stringify(deploymentInfo, null, 2)
  );
  
  console.log("💾 Deployment info saved to deployment-info.json");
}

// Error handling
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:");
    console.error(error);
    process.exit(1);
  });