// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

library AddressSetLib {
    struct Set {
        address[] values;
        mapping(address=>uint256) indexs; 
    }

    function add(Set storage set, address value) internal returns(bool) {
        if(contains(set, value)) {
            return false;
        }
        set.values.push(value);
        set.indexs[value] = set.values.length;
        return true;
    }

    function remove(Set storage set, address value) internal returns(bool) {
        if(!contains(set, value)) {
            return false;
        }
        uint256 index = set.indexs[value];
        uint256 len = set.values.length;
        set.values[index-1] = set.values[len - 1];
        set.indexs[set.values[index-1]] = index;
        set.values.pop();
        delete set.indexs[value];
        return true;
    }

    function contains(Set storage set, address value) internal view returns (bool) {
        return set.indexs[value] > 0;
    }

    function length(Set storage set) internal view returns (uint256) {
        return set.values.length;
    }

    function at(Set storage set, uint256 index) internal view returns (address) {
        require(index > 0 && index < set.values.length, "Invalid index");
        return set.values[index];
    }
}

contract WhiteList {
    AddressSetLib.Set private whiteList;

    using AddressSetLib for AddressSetLib.Set;

    function addToWhiteList(address _address) public {
        require(whiteList.add(_address), "address has added");
    }

    function removeFromWhiteList(address _address) public {
        require(whiteList.remove(_address), "address has not added");
    }

    function lengthOfWhiteList() public view returns (uint256) {
        return whiteList.length();
    }

    function at(uint256 index) public view returns (address) {
        return whiteList.at(index);
    }
}