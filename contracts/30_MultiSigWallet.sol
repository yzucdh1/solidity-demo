// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MultiSigWallet {
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmations;
    }

    uint256 public transactionCount;
    mapping(uint256=>Transaction) public transactions;
    address[] public owners;
    mapping(address=>bool) public isOwner;
    uint256 public required;

    mapping(uint256=>mapping(address=>bool)) public isConfirmed;
    bool private locked;

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners is empty");
        require(_required > 0 && _required <= _owners.length, "Invalid required");
        for (uint256 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }
        required = _required;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "only owner");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "has locked");
        locked = true;
        _;
        locked = false;
    }

    function submit(address _to, uint256 _value, bytes memory _data) external onlyOwner returns (uint256) {
        require(_to != address(0), "Zero address");
        require(_value > 0, "Invalid value");
        uint256 transactionId = transactionCount++;
        transactions[transactionId] = Transaction({
            to : _to,
            value : _value,
            data : _data,
            executed : false,
            confirmations : 0
        });
        return transactionId;
    }

    function confirm(uint256 _transactionId) external onlyOwner {
        require(!isConfirmed[_transactionId][msg.sender], "You have confirmed");

        Transaction storage transaction = transactions[_transactionId];
        require(!transaction.executed, "Transaction already executed");

        transaction.confirmations++;
        isConfirmed[_transactionId][msg.sender] = true;
    }

    function execute(uint256 _transactionId) external onlyOwner nonReentrant {
        Transaction storage transaction = transactions[_transactionId];
        require(!transaction.executed, "Transaction already executed");
        require(transaction.confirmations >= required, "Not enough confirmations");

        transaction.executed = true;
        (bool success, ) = transaction.to.call{gas : 50000, value : transaction.value}(transaction.data);
        require(success, "Transaction failed");
    }

}