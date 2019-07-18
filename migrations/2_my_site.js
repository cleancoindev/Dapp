const MySite = artifacts.require("MySite");

module.exports = function(deployer) {
  deployer.deploy(MySite);
};
