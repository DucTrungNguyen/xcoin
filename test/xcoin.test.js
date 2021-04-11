const XCoin = artifacts.require('XCoin')
const truffleAssert = require('truffle-assertions');
const web3Utils = require('web3-utils')

const {assert, expect} = require('chai')
let contractInstance;
let ownerAddress;
contract('XCoin', accounts => {

    it('should deploy X Coin to Ganache Network', function () {
        return XCoin.deployed().then(
            instance => {
                assert.isObject(instance)
                // expect(instance).to.be.an('object')
            }
        )
    });

    before(async () => {
        contractInstance = await XCoin.deployed()
        ownerAddress = accounts[0]
    })

    // it('should owner is accounts[0]', async function () {
    //     const ownerAddress = await contractInstance.owner();
    //     assert.equal(ownerAddress, accounts[0])
    // });
    // it('should mint when caller is owner', async function () {
    //     await contractInstance.mint(accounts[1], 1000);
    //     const balanceOfAccount1 = await contractInstance.balanceOf(accounts[1])
    //     assert.equal(balanceOfAccount1, 1000*10**6)
    // });
    // it('should error when not owner', async function () {
    //     let errMsg;
    //     try{
    //         await contractInstance.mint(accounts[2], 1000, {
    //             from: accounts[1]
    //         })
    //     }catch (e){
    //         errMsg = e.message
    //     }
    //     assert.match(errMsg, /Only onwer can call/i)
    // });
    //
    // //test function gui tien
    // it('should error khong co tien', async function () {
    //     let errMsg;
    //     try{
    //         await contractInstance.send(accounts[3], 100, {
    //             from: accounts[2]
    //         });
    //
    //     }catch (e) {
    //         errMsg = e.message
    //     }
    //     assert.match(errMsg, /Khong co tien/i)
    // });
    // it('should send money correct', async function () {
    //     const receiver = accounts[3], sender = accounts[1]
    //     const balanceOfSender = await contractInstance.balanceOf(sender);
    //     const transferAmount = 100*10**6
    //     const result = await contractInstance.send(receiver, 100, {
    //         from: sender
    //     })
    //     truffleAssert.eventEmitted(result, 'MoneySent', (ev) => {
    //         return ev._sender === sender
    //             && ev._receiver === receiver
    //             && ev._amount.toNumber() === 100
    //     })
    //     const balanceOfReceiver = await contractInstance.balanceOf(receiver);
    //     assert.equal(balanceOfReceiver, transferAmount);
    //     const balanceOfSenderAfterTransfer = await contractInstance.balanceOf(sender);
    //     assert.equal(balanceOfSender-transferAmount, balanceOfSenderAfterTransfer)
    // });


})
