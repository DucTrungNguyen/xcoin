// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 <= 0.8.1;

interface IXCoinInterface {
    function transferCoinForBorrower(address _borrowerAddress, address _lenderAddress,uint _amount);
    function transferRepayForLender(address _borrowerAddress, address _lenderAddress,uint _amount);
}
