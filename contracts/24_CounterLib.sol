// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

library CounterLib {

    function increment(uint256 value) internal pure returns (uint256) {
        return value + 1;
    }

    function decrement(uint256 value) internal pure returns (uint256) {
        require(value > 0, "Cannot decrement zero");
        return value - 1;
    }

    function reset(uint256) internal pure returns (uint256) {
        return 0;
    }
}

contract Counter {
    uint256 public count;

    using CounterLib for uint256;

    function increment() public {
        count = count.increment();
    }

    function decrement() public {
        count = count.decrement();
    }

    function reset() public {
        count = count.reset();
    } 
}