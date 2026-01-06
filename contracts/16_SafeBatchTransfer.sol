// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SafeBatchTransfer {
    mapping(address=>uint256) public balances;

    uint256 public constant MAX_BATCH_SIZE = 50;

    event Transfer(address indexed from, address indexed to, uint amount);
    event BatchTransfer(address indexed from, uint count, uint totalAmount);

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function safeBatchTransfer(address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "array length mismatch");
        require(recipients.length <= MAX_BATCH_SIZE, "batch size too large");
        
        uint256 totalAmount = 0;
        for (uint i = 0; i < amounts.length; i++ ) {
            totalAmount += amounts[i];
        }
        require(balances[msg.sender] >= totalAmount, "have no enough money");

        for (uint i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid address");
            require(amounts[i] > 0, "Invalid amount");
        }

        for (uint i = 0; i < recipients.length; i++) {
            balances[recipients[i]] += amounts[i];
            balances[msg.sender] -= amounts[i];
            emit Transfer(msg.sender, recipients[i], amounts[i]);
        }

        emit BatchTransfer(msg.sender, recipients.length, totalAmount);
    }

    function getBalance() public view returns(uint256) {
        return balances[msg.sender];
    }
}