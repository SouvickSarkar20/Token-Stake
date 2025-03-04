// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingContract{

    IERC20 public rewardToken;
    address public owner;

    mapping (address => uint256) public stakeBalance;
    mapping(address => uint256) public rewardBalance;

    uint256 public rewardRate = 1;
    //1 RWD token per AVAX staked

    constructor(address _rewardToken){
        rewardToken = IERC20(_rewardToken);
        //this _rewardToken will have the address of the reward token contract
        //this creates an instance of the ERC-20 interface pointing to the contract that is rewardToken 
        //with the help of this , this contract will interact with the rewardtoken contract as if it was an ERC-20 token
        owner = msg.sender;
    }

    function stake() external payable{
        require(msg.value > 0 , "Must stake some AVAX");
        stakeBalance[msg.sender] += msg.value;
        rewardBalance[msg.sender] += msg.value * rewardRate;
    }

    function claimRewards() external{
        uint256 reward = rewardBalance[msg.sender];

        require(reward > 0 , "No rewards to claim");
        rewardBalance[msg.sender] = 0;
        rewardToken.transfer(msg.sender,reward);
    }

    function withdraw() external{
        uint256 staked = stakeBalance[msg.sender];
        require(staked > 0 , "No funds to withdraw");

        stakeBalance[msg.sender] = 0;
        payable(msg.sender).transfer(staked);
    }
}