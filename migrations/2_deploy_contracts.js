const ConvertLib = artifacts.require("libs/ConvertLib");
const XCoin = artifacts.require("XCoin");
const LoanContract = artifacts.require("LoanContract");
const IXCoinInterface = artifacts.require("interfaces/IXCoinInterface");

module.exports = function (deployer) {
    deployer.deploy(ConvertLib);
    deployer.deploy(IXCoinInterface);
    deployer.link(ConvertLib, XCoin);
    deployer.link(IXCoinInterface, XCoin);
    deployer.link(ConvertLib, LoanContract);
    deployer.link(IXCoinInterface, LoanContract);
    deployer.deploy(XCoin);
    deployer.deploy(LoanContract);
};
