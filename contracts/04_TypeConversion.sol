// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract TypeConversion {
    function safeConvertToUint8(uint256 value) public pure returns (uint8) {
        require(value <= type(uint8).max, "value too large for uint8");
        return uint8(value);
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    function isZeroAddress(address addr) public pure returns (bool) {
        return addr == address(0);
    }

}
