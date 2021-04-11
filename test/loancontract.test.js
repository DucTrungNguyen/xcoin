const {assert} = require('chai')
const truffleAssert = require('truffle-assertions');
const XCoin = artifacts.require('XCoin')
const LoanContract = artifacts.require('LoanContract')

let loanContractInstance;
let XCoinInstance;

contract('LoanContract', accounts => {
    it('should create loan contract instance', function () {
        return XCoin.deployed().then(
            async XCoinInstance => {
                assert.isObject(XCoinInstance)


                loanContractInstance = await loanContractInstance.new();
                loanContractInstance.setXCoinContractAddress(XCoinInstance.address);
                assert.isObject(XCoinInstance)

                await XCoinInstance.setLoanContractAddress(loanContractInstance.address);

                const loanContractAddress = await XCoinInstance.loanContractAddress.call();
                assert.equal(loanContractAddress, loanContractInstance.address)
            }
        )
    });

    it('should create lending offer', async function () {
        let tx = await  loanContractInstance.createLendingOffer(accounts[0], 2000, 1000, 15, 2);
        truffleAssert.eventEmitted(tx, 'CreateLendingOfferSuccess', ev => ev.id === 1)


    });

    it('should borrowingXCoin', async function () {
        let tx = await loanContractInstance.borrowingXCoin(1);

    });

    it('should getProfitLending', async function () {
        
    });

    it('should getAmountRepay', async function () {

    });

})
