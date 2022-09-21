const { ethers } = require("hardhat");

async function main() {
    const GognumbNFT = await ethers.getContractFactory("GognumbNFT");

    const gognumbNFT = await GognumbNFT.deploy();
    await gognumbNFT.deployed();
    console.log("Contract deployed to address:", gognumbNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });
