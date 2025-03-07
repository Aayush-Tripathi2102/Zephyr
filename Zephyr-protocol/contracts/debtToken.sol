// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract debtToken is ERC20 {
    constructor() ERC20("Debt token", "dToken") {}

    function mint(address user, uint256 amount) external  {
        _mint(user, amount);
    }

    function burn(address from, uint256 amount) external  {
        _burn(from, amount);
    }
}