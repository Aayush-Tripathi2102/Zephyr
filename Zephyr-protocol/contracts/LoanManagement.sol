// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./CollateralManagement.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LoanManagement {
    CollateralManagement public collateralManager;
    IERC20 public stableCoin;
    address public liquidityPool;

    constructor(
        address _stableCoin,
        address _liquidityPool,
        address _collateralManager
    ) {
        stableCoin = IERC20(_stableCoin);
        liquidityPool = _liquidityPool;
        collateralManager = CollateralManagement(_collateralManager);
    }
    struct Loan {
        uint256 year;
        address borrower;
        uint256 amount;
        bool isRepaid;
    }

    mapping(address => Loan) public loans;

    event LoanCreated(address indexed borrower, uint256 year, uint256 amount);
    event LoanRepaid(address indexed borrower, uint256 amount);
    event LoanCredited(address indexed borrower, uint256 amount);
    uint256 public collateral;

    function createLoan(
        address collateralToken,
        uint256 collateralAmount,
        uint256 loanAmount,
        uint256 year
    ) external {
        require(collateralAmount > 0, "Collateral must be greater than zero");
        require(loanAmount > 0, "Loan amount must be greater than zero");
        require(
            loans[msg.sender].amount == 0,
            "Existing loan must be repaid first"
        );

        // Lock collateral before approving loan
        collateralManager.lockCollateral(
            msg.sender,
            collateralToken,
            collateralAmount
        );

        // Approve the loan amount on behalf of liquidityPool
        IERC20(stableCoin).approve(address(this), 1000e18);

        // Create loan record
        loans[msg.sender] = Loan(year, msg.sender, loanAmount, false);

        emit LoanCreated(msg.sender, year, loanAmount);

        // Transfer loan amount to borrower
        stableCoin.transferFrom(liquidityPool, msg.sender, loanAmount);
    }

    function repayLoan() external {
        require(loans[msg.sender].amount > 0, "No active loan to repay");
        require(!loans[msg.sender].isRepaid, "Loan already repaid");
        require(
            stableCoin.balanceOf(msg.sender) >=
                loans[msg.sender].amount +
                    ((loans[msg.sender].amount * loans[msg.sender].year * 9) /
                        100),
            "Insufficient collateral balance"
        );

        stableCoin.transferFrom(
            msg.sender,
            liquidityPool,
            loans[msg.sender].amount +
                ((loans[msg.sender].amount * loans[msg.sender].year * 9) / 100)
        );
        loans[msg.sender].isRepaid = true;

        // Unlock collateral after successful repayment
        collateralManager.unlockCollateral(msg.sender);

        emit LoanRepaid(msg.sender, loans[msg.sender].amount);
    }

    function getLoan(address borrower) external view returns (uint256, bool) {
        return (loans[borrower].amount, loans[borrower].isRepaid);
    }
}
