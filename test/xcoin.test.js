const XCoin = artifacts.require('XCoin')
const truffleAssert = require('truffle-assertions');
const web3Utils = require('web3-utils')

const {assert, expect} = require('chai')
let XCoinContractInstance;
let ownerAddress;
contract('XCoin', accounts => {

    it('should deploy X Coin to Ganache Network', function () {
        return XCoin.deployed().then(
            instance => {
                assert.isObject(instance)
            }
        )
    });

    before(async () => {
        XCoinContractInstance = await XCoin.deployed()
        ownerAddress = accounts[0]
    });

    it('should transferCoinForBorrower',  async function () {


        const accountSenderBefore =  XCoinContractInstance.balanceOf(accounts[1]);
        const amount = 2*10**16;
        await XCoinContractInstance.transferCoinForBorrower(accounts[0], accounts[1], amount);

        const accountSenderAfter =  XCoinContractInstance.balanceOf(accounts[1]);

        assert.equal(accountSenderBefore-amount, accountSenderAfter);

    });


    it('should transferRepayForLender',  async function () {

        const accountSenderBefore =  XCoinContractInstance.balanceOf(accounts[0]);
        const amount = 2.2*10**16;
        await XCoinContractInstance.transferRepayForLender(accounts[0], accounts[1], amount);
        const accountSenderAfter =  XCoinContractInstance.balanceOf(accounts[0]);
        assert.equal(accountSenderBefore-amount, accountSenderAfter);

    });


})
