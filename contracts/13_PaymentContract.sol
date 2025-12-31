// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract PaymentContract {
    address public owner;
    bool public paused = false;

    mapping(address=>uint256) public balances;

    uint256 public constant MIN_DEPOSIT = 1 ether;

    event Deposit(address indexed _from, uint256 _amount);
    event Withdraw(address indexed _to, uint256 _amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do this");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "Contract is not paused");
        _;
    }

    modifier minDeposit() {
        require(msg.value >= MIN_DEPOSIT, "Minimum deposit is 1 ether");
        _;
    }

    receive() external payable {
        deposit();
     }

    function deposit() public payable whenNotPaused minDeposit {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public payable whenNotPaused {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).call{value: _amount};
        emit Withdraw(msg.sender, _amount);
    }

    function pause() public onlyOwner whenNotPaused {
        paused = true;
    }

    function unpause() public onlyOwner whenPaused {
        paused = false;
    }

    function queryBalance() public view whenNotPaused returns (uint256) {
        return balances[msg.sender];
    }

}