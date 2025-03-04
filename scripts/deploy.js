const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contract with the account:", deployer.address);

    const RewardToken = await ethers.getContractFactory("RewardToken");
    const rewardToken = await RewardToken.deploy();
    await rewardToken.waitForDeployment();

    // ✅ Fetch the correct contract address
    const rewardTokenAddress = rewardToken.target; // <--- Use `target` instead of `.getAddress()`
    console.log("Reward contract deployed at:", rewardTokenAddress);

    const StakingContract = await ethers.getContractFactory("StakingContract");
    const stakingContract = await StakingContract.deploy(rewardTokenAddress);
    await stakingContract.waitForDeployment();

    console.log("Staking Contract deployed at:", stakingContract.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
