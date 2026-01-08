// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SimpleBank {
    error InsufficientBalance(address sender, uint256 balance, uint256 withdrawAmount);
    error WithdrawalFailed();

    mapping(address=>uint256) public balanceof;

    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed sender, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "amount must greater than zero");
        balanceof[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "amount must greater than zero");
        if(balanceof[msg.sender] < amount) {
            revert InsufficientBalance(msg.sender, balanceof[msg.sender], amount);
        }
        balanceof[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value:amount}("");
        if (!success) {
            balanceof[msg.sender] += amount; // Revert the balance change if the transfer failed
            revert WithdrawalFailed();
        }
        emit Withdraw(msg.sender, amount);
    }
}