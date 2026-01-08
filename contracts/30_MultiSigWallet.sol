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

    Transaction[] public transactions;
    address[] public owners;
    mapping(address=>bool) public isOwner;
    uint256 public required;

    mapping(uint256=>mapping(address=>bool)) public isConfirmed;
    bool public locked;

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

    function submit(address _to, uint256 _value, bytes memory data) external onlyOwner {

    }
}