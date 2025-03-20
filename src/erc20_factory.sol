// SPDX-License-identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MintableERC20 is ERC20, Ownable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

contract ERC20Factory {
    address owner;
    
    struct TokenInfo {
        address tokenAddress;
        address creator;
    }
    
    mapping(uint => TokenInfo) public tokenInfo;
    uint256 public contractCount;

    constructor() {
        owner = msg.sender;
        contractCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function createERC20(string memory name, string memory symbol, uint256 totalSupply, address creator)
        public
        returns (address)
    {
        MintableERC20 token = new MintableERC20(name, symbol);
        token.transferOwnership(creator);
        if (totalSupply > 0) {
            token.mint(creator, totalSupply);
        }
        
        contractCount++;
        tokenInfo[contractCount] = TokenInfo(address(token), creator);
        return address(token);
    }

    function getContractAddress(uint256 index) public view returns (address) {
        return tokenInfo[index].tokenAddress;
    }

    function getTokenCreator(uint256 index) public view returns (address) {
        return tokenInfo[index].creator;
    }

    function getAllContractAddress() public view onlyOwner returns (address[] memory) {
        address[] memory addresses = new address[](contractCount);
        for (uint256 i = 0; i < contractCount; i++) {
            addresses[i] = tokenInfo[i + 1].tokenAddress;
        }
        return addresses;
    }
}
