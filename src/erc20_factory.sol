// SPDX-License-identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Factory {
    address owner;
    mapping(unit => address) contractAddress;

    uint256 public contractCount;

    constructor() {
        owner = msg.sender;
        contractCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function createERC20(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address owner)
        public
        returns (address)
    {
        ERC20 token = new ERC20(name, symbol, decimals, totalSupply);
        token.transferOwnership(owner);
        contractCount++;
        contractAddress[contractCount] = address(token);
        return address(token);
    }

    function getContractAddress(uint256 index) public view returns (address) {
        return contractAddress[index];
    }

    function getAllContractAddress() public view onlyOwner returns (address[] memory) {
        address[] memory addresses = new address[](contractCount);
        for (uint256 i = 0; i < contractCount; i++) {
            addresses[i] = contractAddress[i + 1];
        }
        return addresses;
    }
}
