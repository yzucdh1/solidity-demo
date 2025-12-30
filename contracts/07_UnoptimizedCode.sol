// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract UnoptimizedCode {
    uint[] public data;
    
    function process(uint[] calldata values) public {
        uint len = values.length;
        for(uint i = 0; i < len; i++) {
            if(values[i] > 10) {
                data.push(values[i]);
            }
        }
    }
}