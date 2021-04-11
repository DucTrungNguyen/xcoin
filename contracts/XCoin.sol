// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 <= 0.8.1;

//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';
import "./libs/ConvertLib.sol";

contract XCoin is ERC20 {

    address  public owner;
    address  public loanContractAddress;
    uint rateValue = 10;

    event TransferForBorrowerSuccess();
    event TransferRepayForLenderSuccess();

    modifier onlyOwner(){
        require(owner == msg.sender, 'Only owner can call');
        _;
    }

    modifier onlyLoanContract(){
        require(loanContractAddress == msg.sender, 'Only loan contract can call');
        _;
    }

    // Constructor for XCoin
    constructor() ERC20('X Coin', 'XCXC') {
        owner = msg.sender;
    }

    // Mint XCoin for only owner
    function mint(uint _amount) public onlyOwner {
        _mint(msg.sender, ConvertLib.convertXCoinToWei(_amount));
    }


    // send coin P2P
    function sendXCoin(address _receiver, uint _amountSend) public {
        _transfer(msg.sender, _receiver, ConvertLib.convertXCoinToWei(_amountSend));
    }

    function setLoanContractAddress(address _address) public{
        loanContractAddress = _address;
    }

    // lender -> borrower
    function transferCoinForBorrower(address _borrowerAddress, address _lenderAddress, uint _amount) public
    onlyLoanContract {

        _transfer(_lenderAddress, _borrowerAddress,_amount );
    }


    // borrower -> lender, contract -> eth for borrower
    function transferRepayForLender(address _borrowerAddress, address _lenderAddress, uint _amountXCoin, uint _amountETH) public
    onlyLoanContract {

        _transfer(_borrowerAddress, _lenderAddress,_amountXCoin );

        payable(_borrowerAddress).transfer(_amountETH);

    }


}
