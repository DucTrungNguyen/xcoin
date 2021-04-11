// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 <= 0.8.1;

import './interfaces/IXCoinInterface.sol';
import "./libs/ConvertLib.sol";

contract LoanContract {

    struct LendingOffer {
        uint lendingOfferId;
        uint amountXCoin;
        uint ethRequire;
        uint ratingLoanPerETH;
        uint durationSecond;
        uint durationDate;
        uint dailyInterest;
        address addressLender;
        bool isLending;
    }

    struct Borrower {
        address addressBorrower;
        uint timestampStart;
    }

    uint lendingOfferIdIndex = 0;
    uint public constant ratingFee = 5;
    uint public constant secondPerDay = 86400;


    mapping(uint => LendingOffer) public mappingLendingOffer;

    mapping(uint => Borrower) public mappingLending;

    address XCoinContractAddress;
    constructor(address _XCoinContractAddress){
        XCoinContractAddress = _XCoinContractAddress;
    }

    event CreateLendingOfferSuccess(uint lendingId);
    event BorrowingSuccess(uint timestamp);

    event RepaySuccess(uint timestamp);


    function createLendingOffer(address addressLender,
        uint amountLending,
        uint ratingLoan,
        uint durationDates,
        uint dailyInterest) public returns (uint)
    {
        require(amountLending > 0, "Require amount fo lending offer more than 0");
        require(ratingLoan > 0, 'Rating loan more than 0');
        require(durationSeconds > 0, "Duration more than 0");
        require(dailyInterest > 0, "Daily interest more than 0");

        lendingOfferIdIndex++;

        uint _ethRequire = ConvertLib.convertToETHRequireLending(amountLending, ratingLoan);
        mappingLendingOffer[lendingOfferIdIndex] =
        LendingOffer({
        lendingOfferId : lendingOfferIdIndex,
        amountXCoin : amountLending,
        ethRequire : _ethRequire,
        ratingLoanPerETH : ratingLoan,
        durationSecond : durationDates * secondPerDay,
        durationDate : durationDates,
        dailyInterest : dailyInterest,
        addressLender : addressLender,
        isLending : false
        });
        emit CreateLendingOfferSuccess(lendingOfferIdIndex);
        return lendingOfferIdIndex;
    }

    function borrowingXCoin(uint _lendingId) public payable {

        require(ConvertLib.convertETHToWei(msg.value) == mappingLendingOffer[_lendingId].ethRequire, 'EHT must be equal ETH require');
        require(mappingLendingOffer[_lendingId].isLending == false, 'Must be ready for lending');

        mappingLendingOffer[_lendingId].isLending = true;
        mappingLending[_lendingId] = Borrower({
        addressBorrower : msg.sender,
        timestampStart : block.timestamp
        });
        IXCoinInterface(XCoinContractAddress).transferCoinForBorrower(msg.sender,
            mappingLendingOffer[_lendingId].addressLender, mappingLendingOffer[_lendingId].amountXCoin);

        emit BorrowingSuccess(block.timestamp);

    }


    function repayBorrowingXCoin(uint _lendingIdToRepay, uint _amountRepay) public {
        require(msg.sender == mappingLending[_lendingIdToRepay].addressBorrower, 'Only borrower can repay');
        require(ConvertLib.convertXCoinToWei(_amountRepay) == getAmountRepay(_lendingIdToRepay), 'amount to repay not correctly');

        IXCoinInterface(XCoinContractAddress).transferRepayForLender(msg.sender,
            mappingLendingOffer[_lendingId].addressLender, ConvertLib.convertXCoinToWei(_amountRepay));


        mappingLendingOffer[_lendingIdToRepay].isLending = false;
        delete mappingLending[_lendingIdToRepay];


        emit RepaySuccess(block.timestamp);

    }

    function getAmountRepay(uint _lendingId) private view returns (uint) {

        bool  isPayFee = false;
        uint payFee;
        uint XCoinTotalPay;
        uint currentTimeStamp = bloc.timestamp;

        if ( currentTimeStamp - mappingLending[_lendingId].timestampStart < mappingLendingOffer[_lendingId].durationSecond){
            isPayFee = true;
            payFee = ConvertLib.convertXCoinToWei((ratingFee*mappingLendingOffer[_lendingId].amountXCoin)/100);
        }

        if ( isPayFee == false) {
            XCoinTotalPay = mappingLendingOffer[_lendingId].amountXCoin + getProfitLending(_lendingId, isPayFee);

        }else {
            XCoinTotalPay = mappingLendingOffer[_lendingId].amountXCoin + payFee + getProfitLending(_lendingId, isPayFee);
        }
        return  ConvertLib.convertXCoinToWei(XCoinTotalPay);
    }

    function getProfitLending(uint _IDLending, bool isPayFee) public view returns (uint){

        uint profitXCoin;
        uint _currentTimeStamp = block.timestamp;
        uint profitPerDay = (mappingLendingOffer[_IDLending].dailyInterest * mappingLendingOffer[_IDLending].amountXCoin) / 100;
        if ( isPayFee == false){

            profitXCoin= profitPerDay  * mappingLendingOffer[_IDLending].durationDate;
        }else {
            uint timeBorrowByDay;
            uint timeBorrowBySecond = currentTimeStamp - mappingLending[_lendingId].timestampStart;
            uint modTimeSecond = timeBorrowBySecond  % secondPerDay;
            if ( modTimeSecond == 0) {
                timeBorrowByDay = (timeBorrowBySecond - modTimeSecond) / secondPerDay;

            }else if ( modTimeSecond > 0) {
                timeBorrowByDay = (timeBorrowBySecond - modTimeSecond) / secondPerDay + 1;

            }

            profitXCoin = profitPerDay*timeBorrowByDay;
        }

        return profitXCoin;

    }


}
