const ANSStorage = artifacts.require("ANSStorage");
const ANS = artifacts.require("ANS");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ANS, accounts[0])
  .then(() => {
    return deployer.deploy(ANSStorage, ANS.address);
  });
};
