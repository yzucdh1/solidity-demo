// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Crowdfunding {
    error CampaignNotActive();
    error CampaignAlreadyEnded();
    error GoalNotReached(uint256 current, uint256 goal);
    error GoalAlreadyReached();
    error InvalidAmount(uint256 amount);
    error Unauthorized(address caller);
    error RefundFailed(address contributor);
    error WithdrawalFailed();
    error AlreadyRefunded(address contributor);

    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public ended;
    bool public goalReached;
    
    mapping(address => uint256) public contributions;
    mapping(address => bool) public refunded;

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized(msg.sender);
        _;
    }

    constructor(uint256 _goal, uint256 _duration) {
        require(_goal > 0, "goal must greater than zero");
        require(_duration > 0, "duration must greater than zero");

        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    event Contribution(address indexed contributor, uint256 amount);
    event GoalReached(uint256 totalAmount);
    event Withdrawal(address indexed owner, uint256 amount);
    event Refund(address indexed contributor, uint256 amount);
    
    function contribute() public payable {
        if (ended) {
            revert CampaignAlreadyEnded();
        }
        if (block.timestamp >= deadline) {
            revert CampaignNotActive();
        }
        if (msg.value <= 0) {
            revert InvalidAmount(msg.value);
        }

        // 2. Effects: 更新状态
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
        
        // 检查是否达到目标
        if (!goalReached && totalRaised >= goal) {
            goalReached = true;
            emit GoalReached(totalRaised);
        }
        
        // 3. Interactions: 触发事件
        emit Contribution(msg.sender, msg.value);
    }

    function endCampaign() public {
        require(block.timestamp >= deadline, "crowdfunding has not ended");
        require(!ended, "crowdfunding has ended");

        ended = true;

        if (totalRaised >= goal) {
            goalReached = true;
        }
    }
}