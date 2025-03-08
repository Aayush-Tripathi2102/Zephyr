// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract CollateralManagement {
    using SafeERC20 for IERC20;

    struct Collateral {
        address token;
        uint256 amount;
    }

    mapping(address => Collateral) public lockedCollateral;

    event CollateralLocked(
        address indexed user,
        address indexed collateralToken,
        uint256 amount
    );
    event CollateralUnlocked(
        address indexed user,
        address indexed collateralToken,
        uint256 amount
    );
    event DebugAllowance(uint256 allowance, uint256 amountNeeded);

    modifier onlyBorrower(address user) {
        require(msg.sender == user, "Only borrower can unlock collateral");
        _;
    }

    function lockCollateral(
        address user,
        address collateralToken,
        uint256 amount
    ) external {
        require(amount > 0, "Collateral amount must be greater than zero");

        uint256 allowance = IERC20(collateralToken).allowance(
            user,
            address(this)
        );

        emit DebugAllowance(allowance, amount);

        IERC20(collateralToken).safeTransferFrom(user, address(this), amount);

        if (lockedCollateral[user].token == address(0)) {
            lockedCollateral[user] = Collateral(collateralToken, amount);
        } else {
            require(
                lockedCollateral[user].token == collateralToken,
                "Collateral token mismatch"
            );
            lockedCollateral[user].amount += amount;
        }

        emit CollateralLocked(user, collateralToken, amount);
    }

    function unlockCollateral(address user) external onlyBorrower(user) {
        require(lockedCollateral[user].amount > 0, "No collateral to unlock");

        uint256 amount = lockedCollateral[user].amount;
        address token = lockedCollateral[user].token;

        delete lockedCollateral[user];

        IERC20(token).safeTransfer(user, amount);

        emit CollateralUnlocked(user, token, amount);
    }

    function getCollateral(
        address user
    ) external view returns (address, uint256) {
        return (lockedCollateral[user].token, lockedCollateral[user].amount);
    }
}
