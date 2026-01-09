// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Implementation {
    address public implementation;
    uint256 public value;
    address public owner;

    function setValue(uint256 _value) external {
        value = _value;
    }

    function getValue() external view returns (uint256) {
        return value;
    }
}

contract ProxyContract {
    address public implementation;
    uint256 public value;
    address public owner;

    constructor(address _implementation) {
        require(address(0) != _implementation, "Implementation address cannot be zero");
        implementation = _implementation;
        owner = msg.sender;
    }

    function upgrade(address _newImplementation) external {
        require(msg.sender == owner, "Only owner");
        require(address(0) != _newImplementation, "New implementation address cannot be zero");
        implementation = _newImplementation;
    }

    fallback() external payable {
        (bool success, bytes memory returnData) = implementation.delegatecall(msg.data);

        if (!success) {
            assembly {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        } else {
            assembly {
                return(add(returnData, 0x20), mload(returnData))
            }
        }
    }

    receive() external payable {}
}