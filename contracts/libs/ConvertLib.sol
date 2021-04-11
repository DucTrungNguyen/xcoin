// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 <= 0.8.1;

library ConvertLib {


    // 1 eth = 1.000.000.000 Gwei = 1.000.000.000.000.000.000 (1e18) wei
    // 1 eth = 100 XCoin => 1 XCoin = 10.000.000 Gwei =10.000.000.000.000.000 (1e16) wei
    function convert(uint amount, uint conversionRate) public pure returns (uint convertedAmount)
    {
        return amount * conversionRate;
    }

    function convertToETHRequireLending(uint amount, uint ratingLoanPerETH) public pure returns (uint convertedAmount)
    {
        // Sum XCoin = 2000 => ?ETH
        // rate 1000XCoin = 1ETH

        // 2000 :
        //1000 : 1
        uint ethRequire = convertETHToWei((amount / ratingLoanPerETH));
        return ethRequire;
    }


    function convertETHToWei(uint amountETH) public pure returns (uint convertedAmount)
    {
        require(amountXCoin > 0, "Amount ETH coin require more than 0");
        return amountETH * 10 ** 18;
    }


    function convertXCoinToWei(uint amountXCoin) public pure returns (uint convertedAmount) {
        require(amountXCoin > 0, "Amount X coin require more than 0");
        return amountXCoin * 10 ** 16;

    }


}
