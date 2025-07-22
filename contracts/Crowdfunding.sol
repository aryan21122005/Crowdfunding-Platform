// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public totalFunds;
    bool public goalReached;

    mapping(address => uint) public contributions;

    event ContributionReceived(address contributor, uint amount);
    event GoalReached(uint totalAmount);
    event Refunded(address contributor, uint amount);

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
        goalReached = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp <= deadline, "Deadline passed");
        _;
    }

    function contribute() public payable beforeDeadline {
        require(msg.value > 0, "Must send ETH");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        emit ContributionReceived(msg.sender, msg.value);

        if (totalFunds >= goal && !goalReached) {
            goalReached = true;
            emit GoalReached(totalFunds);
        }
    }

    function withdrawFunds() public onlyOwner {
        require(goalReached, "Goal not reached");
        payable(owner).transfer(address(this).balance);
    }

    function getRefund() public {
        require(block.timestamp > deadline, "Campaign still active");
        require(!goalReached, "Goal was reached");
        uint amount = contributions[msg.sender];
        require(amount > 0, "Nothing to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit Refunded(msg.sender, amount);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // ✅ New Function: Get contribution details of any address
    function getContributorDetails(address contributor) public view returns (uint amountContributed) {
        return contributions[contributor];
    }
}
