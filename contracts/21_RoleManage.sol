// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }
}

contract Pausable {
    bool public paused;

    modifier whenNotPaused() {
        require(!paused, "contract has paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "contract has not paused");
        _;
    }

    function _pause() internal whenNotPaused {
        paused = true;
    }

    function _unpause() internal whenPaused {
        paused = false;
    }
}

contract MyContract is Ownable, Pausable {
    uint256 public value;

    function setValue(uint256 _value) public onlyOwner whenNotPaused {
        value = _value;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}