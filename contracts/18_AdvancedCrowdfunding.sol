// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract AdvancedCrowdfunding is ReentrancyGuard {
    enum State {Fundraising, Successful, Failed, PaidOut}

    State public currentState;

    address public immutable creator;
    uint256 public immutable goal;
    uint256 public immutable deadline;
    
    uint256 public totalFunded;
    uint256 public contributorCount;
    mapping(address => uint256) public contributions;
    address[] public contributors;

    event StateChanged(State oldState, State newState, uint timestamp);
    event Contribution(address indexed contributor, uint amount, uint totalFunded);
    event FundsWithdrawn(address indexed creator, uint amount);
    event Refunded(address indexed contributor, uint amount);

    constructor(uint256 _goal, uint256 _duration) {
        creator = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
        currentState = State.Fundraising;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state");
        _;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Only creator can call this function");
        _;
    }

    function contribution() public inState(State.Fundraising) payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value > 0, "Contribution must be greater than zero");

        if (contributions[msg.sender] == 0) {
            contributorCount++;
            contributors.push(msg.sender);
        }
        contributions[msg.sender] += msg.value;
        totalFunded += msg.value;

        emit Contribution(msg.sender, msg.value, totalFunded);

        if (totalFunded >= goal) {
            currentState = State.Successful;
            emit StateChanged(State.Fundraising, State.Successful, block.timestamp);
        }
    }

    function checkFundingState() public onlyCreator inState(State.Fundraising) {
        require(block.timestamp >= deadline, "Funding period has not ended yet");
        if (totalFunded < goal) {
                currentState = State.Failed;
                emit StateChanged(State.Fundraising, State.Failed, block.timestamp);
            } else {
                currentState = State.Successful;
                emit StateChanged(State.Fundraising, State.Successful, block.timestamp);
            }
    }

    function fundsWithdrawn() public inState(State.Successful) onlyCreator nonReentrant {
        currentState = State.PaidOut;
        uint amount = address(this).balance;
        (bool success, ) = msg.sender.call{value:amount}("");
        require(success, "withdraw failed");

        emit FundsWithdrawn(creator, amount);
        emit StateChanged(State.Successful, State.PaidOut, block.timestamp);
    }

    function refunded() public inState(State.Failed) nonReentrant {
        require(contributions[msg.sender] > 0, "You did not contribute");
        uint amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value:amount}("");
        require(success, "refund failed");
        emit Refunded(msg.sender, amount);
    }

}