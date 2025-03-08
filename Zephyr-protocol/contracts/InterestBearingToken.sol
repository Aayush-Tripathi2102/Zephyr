// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InterestBearingToken is ERC20, Ownable {
    address public lendingPool;
    uint256 public exchangeRate;
    uint256 public constant INITIAL_EXCHANGE_RATE = 1e18; // 1:1 initial rate

    event ExchangeRateUpdated(uint256 newRate);
    event LendingPoolUpdated(address newLendingPool);

    constructor() ERC20("InterestBearingToken", "IBT") Ownable(msg.sender) {
        exchangeRate = INITIAL_EXCHANGE_RATE; // Set initial exchange rate
    }

    function setLendingPool(address _lendingPool) external onlyOwner {
        require(lendingPool == address(0), "Lending pool already set");
        lendingPool = _lendingPool;
        emit LendingPoolUpdated(_lendingPool);
    }

    modifier onlyLendingPool() {
        require(msg.sender == lendingPool, "Only lending pool can call this");
        _;
    }

    function mintTokens(address lender, uint256 stablecoinAmount) external onlyLendingPool {
        uint256 tokensToMint = (stablecoinAmount * 1e18) / exchangeRate;
        _mint(lender, tokensToMint);
    }

    function burnTokens(address lender, uint256 tokenAmount) external onlyLendingPool {
        _burn(lender, tokenAmount);
    }

    function updateExchangeRate(uint256 newExchangeRate) external onlyLendingPool {
        require(newExchangeRate > 0, "Invalid exchange rate");
        exchangeRate = newExchangeRate;
        emit ExchangeRateUpdated(newExchangeRate);
    }

    function convertToStablecoin(uint256 tokenAmount) external view returns (uint256) {
        return (tokenAmount * exchangeRate) / 1e18;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
}