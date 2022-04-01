//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IBloggerNFT {
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract BloggerDAO is Ownable {
    string[] private blogs;
    mapping(address => uint256[]) postOwners;
    IBloggerNFT private nft;

    constructor(address bloggerNFTAddress) {
        nft = IBloggerNFT(bloggerNFTAddress);
    }

    modifier hasNFT() {
        require(
            nft.balanceOf(msg.sender) > 0,
            "Buy NFT to get access to the blog posts"
        );
        _;
    }

    modifier hasBlog(string memory blog) {
        require(bytes(blog).length != 0, "Empty blog sent, send a valid text");
        _;
    }

    modifier isValidIndex(uint256 index) {
        require(((index < blogs.length) && (index >= 0)), "Index out of range");
        _;
    }

    modifier isPostOwner(uint256 index) {
        uint256[] storage owners = postOwners[msg.sender];
        bool isOwner;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == index) {
                isOwner = true;
            }
        }
        require(isOwner, "Cannot delete post");
        _;
    }

    function deletePostFromMapping(uint256 index, address user) private {
        uint256[] storage owners = postOwners[user];
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == index) {
                delete owners[i];
                owners[i] = owners[owners.length - 1];
                owners.pop();
                break;
            }
        }
        postOwners[user] = owners;
    }

    function postBlog(string memory blog)
        public
        hasNFT
        hasBlog(blog)
        returns (bool)
    {
        blogs.push(blog);
        postOwners[msg.sender].push(blogs.length - 1);
        return true;
    }

    function getBlog(uint256 index)
        public
        view
        hasNFT
        isValidIndex(index)
        returns (string memory)
    {
        return blogs[index];
    }

    function getBlogs() public view hasNFT returns (string[] memory) {
        return blogs;
    }

    function updateBlog(uint256 index, string memory blog)
        public
        hasNFT
        isValidIndex(index)
        hasBlog(blog)
        isPostOwner(index)
        returns (bool)
    {
        delete blogs[index];
        blogs[index] = blog;
        return true;
    }

    function deleteBlog(uint256 index)
        public
        hasNFT
        isValidIndex(index)
        isPostOwner(index)
        returns (bool)
    {
        delete blogs[index];
        blogs[index] = blogs[blogs.length - 1];
        blogs.pop();
        return true;
    }
}
