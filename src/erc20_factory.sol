// SPDX-License-identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Factory {
    function createERC20(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address owner) public returns (address) {
        ERC20 token = new ERC20(name, symbol, decimals, totalSupply);
        token.transferOwnership(owner);
        return address(token);
    }
} 