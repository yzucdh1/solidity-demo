// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Counter {
    address public owner;
    uint256 public count;

    constructor(address _owner) {
        owner = _owner;
        count = 0;
    }

    function increment() external {
        require(msg.sender == owner, "Only owner");
        count += 1;
    }
}

contract CounterFactory {
    event CounterCreated(address indexed counterAddress, bytes32 salt);

    function createWithCreate2(bytes32 _salt) external returns (address) {
        Counter counter = new Counter{salt : _salt}(msg.sender);
        address counterAddress = address(counter);
        emit CounterCreated(counterAddress, _salt);
        return counterAddress;
    }

    function computeAddress(bytes32 _salt, address _creator) external view returns (address) {
        bytes memory bytecode = abi.encodePacked(type(Counter).creationCode, abi.encode(msg.sender));
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), _creator, _salt, keccak256(bytecode)));
        return address(uint160(uint256(hash)));
    }
}