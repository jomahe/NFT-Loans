const hre = require("hardhat");

async function main() {

  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracs with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // We get the contract to deploy
  const SmallLoanPool = await hre.ethers.getContractFactory("SmallLoan");
  const smallLoanPool = await SmallLoanPool.deploy(10);

  await smallLoanPool.deployed();

  console.log("SmallLoanPool deployed to:", smallLoanPool.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
