//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BloggerCoin is ERC20, Ownable {
    uint256 public coinPrice = 0.001 ether;

    constructor() ERC20("BloggerCoin", "BLC") {
        _mint(msg.sender, 1000 * 10**18);
    }

    function mint(uint256 amount) public payable {
        uint256 amountRequired = amount * coinPrice;
        require(msg.value >= amountRequired, "Insufficient ether sent");
        _mint(msg.sender, amount * 10**18);
    }

    function sell(uint256 amount) public {
        require((amount > 0 && amount <= balanceOf(msg.sender)), "Incorrect amount sent");
        _burn(msg.sender, amount * 10**18);
        uint256 eth = amount * coinPrice;
        payable(msg.sender).transfer(eth);
    }

    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {}
}
