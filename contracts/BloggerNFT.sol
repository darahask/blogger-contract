//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IBloggerCoin {
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external returns (bool);
     function transfer(
        address to,
        uint256 tokenId
    ) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract BloggerNFT is ERC721Enumerable, Ownable {
    uint256 public nftPrice = 10;
    uint256 public tokenId = 0;
    IBloggerCoin private coin;

    constructor(address _bloggerTokenAddress) ERC721("BloggerNFT", "BLNFT") {
        coin = IBloggerCoin(_bloggerTokenAddress);
        _safeMint(msg.sender, tokenId);
    }

    function mint() public {
        coin.transferFrom(msg.sender, address(this), nftPrice * 10**18);
        tokenId += 1;
        _safeMint(msg.sender, tokenId);
    }

    function sell() public {
        require(balanceOf(msg.sender) != 0, "No nfts to sell");
        uint256 index = balanceOf(msg.sender) - 1;
        uint256 token = tokenOfOwnerByIndex(msg.sender, index);
        _burn(token);
        coin.transfer(msg.sender, nftPrice * 10**18);
    }
}
