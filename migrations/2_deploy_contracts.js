var SilverToken = artifacts.require("SilverToken");

module.exports = function(deployer) {
  // Arguments are: contract, initialSupply
  deployer.deploy(SilverToken, 1000);
};