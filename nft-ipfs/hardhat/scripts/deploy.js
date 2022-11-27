const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  //url to metadata to extrect metadata

  const metadataURL = "ipfs://Qmbygo38DWF1V8GttM1zy89KzyZTPU2FLUzQtiDvB7q6i5D/";

  const lw3PunksContract = await ethers.getContractFactory("LW3Punks");

  const deployedLW3PunksContract = await lw3PunksContract.deploy(metadataURL);
  console.log("Contract Deploying---");
  await deployedLW3PunksContract.deployed();
  console.log("Contract Deployed++++");
  console.log("Contract address", deployedLW3PunksContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
