const { ethers } = require("hardhat");

async function main() {
  const goalInWei = ethers.utils.parseEther("5"); // Example: 5 ETH goal
  const durationInDays = 7;

  const Crowdfunding = await ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy(goalInWei, durationInDays);

  await crowdfunding.deployed();

  console.log("Crowdfunding contract deployed to:", crowdfunding.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
