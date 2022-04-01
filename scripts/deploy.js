const { ethers } = require("hardhat");

async function main() {
    const coins = await ethers.getContractFactory("BloggerCoin");
    const coinsdeploy = await coins.deploy();
    await coinsdeploy.deployed();

    const nft = await ethers.getContractFactory("BloggerNFT");
    const nftdeploy = await nft.deploy(coinsdeploy.address);
    await nftdeploy.deployed();

    const dao = await ethers.getContractFactory("BloggerDAO");
    const daodeploy = await dao.deploy(nftdeploy.address);
    await daodeploy.deployed();

    console.log("Coin: ", coinsdeploy.address);
    console.log("NFT: ", nftdeploy.address);
    console.log("DAO: ", daodeploy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
