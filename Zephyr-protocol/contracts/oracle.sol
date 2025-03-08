// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PriceFeedOracle is Ownable {
    constructor() Ownable(msg.sender) {}

    mapping(address => address) public tokenPriceFeeds;

    event PriceFeedUpdated(address indexed token, address priceFeed);

    function addPriceFeed(address token, address priceFeed) external onlyOwner {
        tokenPriceFeeds[token] = priceFeed;
        emit PriceFeedUpdated(token, priceFeed);
    }

    function getLatestPrice(address token) external view returns (int256) {
        address priceFeed = tokenPriceFeeds[token];
        require(priceFeed != address(0), "No price feed for token");

        (int256 price, ) = AggregatorV3Interface(priceFeed).latestRoundData();

        return price;
    }

    function getPriceWithDecimals(
        address token
    ) external view returns (int256, uint8) {
        address priceFeed = tokenPriceFeeds[token];
        require(priceFeed != address(0), "No price feed for token");

        (int256 price, ) = AggregatorV3Interface(priceFeed).latestRoundData();

        uint8 decimals = AggregatorV3Interface(priceFeed).decimals();

        return (price, decimals);
    }

    function hasPriceFeed(address token) external view returns (bool) {
        return tokenPriceFeeds[token] != address(0);
    }
}
