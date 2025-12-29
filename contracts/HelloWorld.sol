// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract HelloWorld {
    string message;
    address owner;

    constructor() {
        message = "Hello World";
        owner = msg.sender;
    }

    function getMessage() public view returns(string memory) {
        return message;
    }

    function updateMessage(string memory m) public {
        message = m;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == owner;
    }
}