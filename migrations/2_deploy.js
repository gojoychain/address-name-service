const Utils = artifacts.require("./lib/Utils.sol");
const AddressNameService = artifacts.require("./ans/AddressNameService.sol");

module.exports = function(deployer) {
  deployer.deploy(Utils);
  deployer.link(AddressNameService, Utils);
};
