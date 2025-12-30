// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract RoleManagement {
    enum Role {None, Owner, Admin, User}

    mapping(address=>Role) public roles;
    address public owner;

    constructor() {
        owner = msg.sender;
        roles[msg.sender] = Role.Owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can add admin");
        _;
    }

    modifier onlyOwnerOrAdmin() {
        require(msg.sender == owner || roles[msg.sender] == Role.Admin, "only owner or admin can add user");
        _;
    }

    function addAdmin(address _user) public onlyOwner {
        roles[_user] = Role.Admin;
    }

    function addUser(address _user) public onlyOwnerOrAdmin {
        roles[_user] = Role.User;
    }

    function getRole() public view returns(Role) {
        return roles[msg.sender];
    }

}