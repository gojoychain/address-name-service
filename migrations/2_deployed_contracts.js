const ANSStorage = artifacts.require("ANSStorage");
const ANS = artifacts.require("ANS");
const ANSWrapper = artifacts.require("ANSWrapper");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ANSStorage, accounts[0]);
  deployer.deploy(ANS);
  deployer.link(ANS, ANSWrapper);
  deployer.deploy(ANSWrapper);
};
