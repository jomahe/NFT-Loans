require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/8f93239f811e438dbbcfade45e74b8a7",
      accounts: ["2af366f3f0b053fb0bfd5f315b2bc0dd6ed83f884ddb1ca55a7dc8bce6c27abe",
                 "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"]
    }
  },
  etherscan: {
    apiKey: "E1XP732Z7DP8FWFDY7RYC5W94SUKFN38JJ"
  },
  solidity: "0.8.10",
};
