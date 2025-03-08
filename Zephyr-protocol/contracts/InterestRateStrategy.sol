// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
function getInterest() external {
    uint256 br = calculateBorrowRate();
    uint256 availableLiquidity = stablecoin.balanceOf(address(this));
    uint256 utilization = (totalBorrows == 0)
        ? 0
        : (totalBorrows * 1e18) / (availableLiquidity + totalBorrows);

    uint256 totalInterestEarned = (br * utilization * availableLiquidity) /
        1e18;
    uint256 interest = (stablecoinDeposits[msg.sender] * totalInterestEarned) /
        availableLiquidity;
    uint256 Rate = stablecoinDeposits[msg.sender];

    emit InterestAndRate(interest, Rate);
}
