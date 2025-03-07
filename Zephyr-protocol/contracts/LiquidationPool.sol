// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./aToken.sol";
import "./debtToken.sol";
import "./CollateralManagement.sol";
import "./InterestRateStrategy.sol";

contract LendingPool {
    IERC20 public stablecoin;
    aToken public aTokenContract;
    debtToken public debtTokenContract;

    uint256 public constant OPTIMAL_UTILIZATION_RATE = 80 * 1e16; // 80%
    uint256 public constant EXCESS_UTILIZATION_RATE = 20 * 1e16;  // 20%

    uint256 public immutable baseRate = 5e16 ;
    uint256 public immutable slope1 = 1e14;
    uint256 public immutable slope2 = 5e14;


    struct Collateral {
        IERC20 token;
        uint256 amount;
    }
    
    mapping(address => uint256) public stablecoinDeposits;
    mapping(address => uint256) public borrows;
    mapping(address => uint256) public borrowRates;

    uint256 public totalStablecoinDeposits;
    uint256 public totalBorrows;

    event DepositStablecoin(address indexed user, uint256 amount);
    event WithdrawStablecoin(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);
    event Liquidation(address indexed liquidator, address indexed borrower, uint256 amountLiquidated);
    event LoanRepaid(address indexed borrower, uint256 totalRepaid, uint256 interestPaid);
    event InterestRate(uint256 interest);
    event InterestAndRate (uint interest, uint Rate);


    
    constructor(
        address _stablecoin,
        address _aToken,
        address _debtToken
    ) {
        stablecoin = IERC20(_stablecoin);
        aTokenContract = aToken(_aToken);
        debtTokenContract = debtToken(_debtToken);
    }

    
    function depositStablecoin(uint256 amount) external {
        stablecoin.transferFrom(msg.sender, address(this), amount);
        aTokenContract.mint(msg.sender, amount);
        stablecoinDeposits[msg.sender] += amount;
        totalStablecoinDeposits += amount;
        emit DepositStablecoin(msg.sender, amount);
    }

    function withdrawStablecoin(uint256 amount) external {
        require(stablecoinDeposits[msg.sender] >= amount, "Insufficient balance");
        require(totalStablecoinDeposits - totalBorrows >= amount, "Insufficient liquidity");
        
        stablecoinDeposits[msg.sender] -= amount;
        totalStablecoinDeposits -= amount;
        aTokenContract.burn(msg.sender, amount);
        stablecoin.transfer(msg.sender, amount);
        
        emit WithdrawStablecoin(msg.sender, amount);
    }

    function canBorrow(address user, uint256 amount) public view returns (bool) {
        uint256 collateralValue = getTotalCollateralValue(user);
        uint256 maxBorrow = (collateralValue * 75) / 100;
        return borrows[user] + amount <= maxBorrow;
    }

    

    function getInterest () external {
        uint256 br = calculateBorrowRate();
        uint256 availableLiquidity = stablecoin.balanceOf(address(this));
        uint256 utilization = (totalBorrows == 0) ? 0 : (totalBorrows * 1e18) / (availableLiquidity + totalBorrows);

        uint256 totalInterestEarned= (br * utilization * availableLiquidity) / 1e18;
        uint256 interest = (stablecoinDeposits[msg.sender] * totalInterestEarned) / availableLiquidity;
        uint256 Rate = stablecoinDeposits[msg.sender];

        emit InterestAndRate(interest, Rate);

    }

    function borrow(uint256 amount) external {
        require(canBorrow(msg.sender, amount), "Insufficient collateral");
        debtTokenContract.mint(msg.sender, amount);
        borrows[msg.sender] += amount;
        totalBorrows += amount;
        stablecoin.transfer(msg.sender, amount);
        borrowRates[msg.sender] = calculateBorrowRate();
        emit Borrow(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        require(borrows[msg.sender] > 0, "No outstanding debt");
        debtTokenContract.burn(msg.sender, amount);

        // Calculate interest = (principal * rate * time) / 1e18
        uint256 principal = borrows[msg.sender];
        uint256 interest = (principal * borrowRates[msg.sender]) / 1e18; // Assuming time = 1 period for simplicity

        uint256 totalRepay = principal + interest;

        require(amount >= totalRepay, "Insufficient amount to repay loan");

        // Transfer stablecoins from borrower to the contract
        stablecoin.transferFrom(msg.sender, address(this), totalRepay);

        // Reduce total borrows and reset borrower's debt
        totalBorrows -= principal;
        borrows[msg.sender] = 0;

        // **Return collateral**
        for (uint256 i = 0; i < collateralDeposits[msg.sender].length; i++) {
            Collateral memory coll = collateralDeposits[msg.sender][i];
            coll.token.transfer(msg.sender, coll.amount);
        }
        delete collateralDeposits[msg.sender]; // Remove collateral records

        emit LoanRepaid(msg.sender, totalRepay, interest);
        emit WithdrawStablecoin(msg.sender, totalRepay);
    }

    function liquidate(address borrower) external {
        uint256 collateralRatio = checkCollateralRatio(borrower);
        require(collateralRatio >= 75 * 1e16, "Not eligible for liquidation");
        uint256 debtAmount = borrows[borrower];
        for (uint256 i = 0; i < collateralDeposits[borrower].length; i++) {
            collateralDeposits[borrower][i].token.transfer(msg.sender, collateralDeposits[borrower][i].amount);
        }
        delete collateralDeposits[borrower];
        debtTokenContract.burn(borrower, debtAmount);
        emit Liquidation(msg.sender, borrower, debtAmount);
    }

    
}
