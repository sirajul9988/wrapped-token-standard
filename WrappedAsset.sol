// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title WrappedAsset
 * @dev Implementation of a WETH-style wrapped native token.
 */
contract WrappedAsset is ERC20 {
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    /**
     * @dev Fallback to allow simple transfers to wrap tokens.
     */
    receive() external payable {
        deposit();
    }

    /**
     * @dev Deposit native currency to receive wrapped ERC-20 tokens.
     */
    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev Burn wrapped tokens to receive native currency back.
     */
    function withdraw(uint wad) public {
        require(balanceOf(msg.sender) >= wad, "Insufficient balance");
        _burn(msg.sender, wad);
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    /**
     * @dev Returns the total native currency held by the contract.
     */
    function totalNativeSupply() public view returns (uint) {
        return address(this).balance;
    }
}
