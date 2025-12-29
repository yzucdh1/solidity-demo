// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SimpleToken {
    string public constant name = "My Token";
    string public constant symbol = "MTK";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    address public immutable owner;
    mapping(address=>uint256) balanceOf;

    // 事件
    event Transfer(address _from, address _to, uint256 amount); 

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _amount) public returns (bool) {
        require(_to != address(0), "0 address");
        require(balanceOf[msg.sender] >= _amount, "have no enough balance");
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function getBalance(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }

    function mint(address _to, uint256 _amount) public {
        require(msg.sender == owner, "only owner can do this");
        require(_to != address(0), "0 address");
        totalSupply += _amount;
        balanceOf[_to] += _amount;
        emit Transfer(address(0), _to, _amount);
    }

}