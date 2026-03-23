const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const WrappedAsset = await hre.ethers.getContractFactory("WrappedAsset");
  // Deploying as "Wrapped Ethereum" or whatever native asset is on the chain
  const wAsset = await WrappedAsset.deploy("Wrapped Ether", "WETH");

  await wAsset.waitForDeployment();
  const address = await wAsset.getAddress();

  console.log("Wrapped Asset deployed to:", address);

  // Example Wrap
  const depositTx = await wAsset.deposit({ value: hre.ethers.parseEther("1.0") });
  await depositTx.wait();
  
  console.log("Successfully wrapped 1.0 Native Token.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
