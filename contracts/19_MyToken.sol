// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MyToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public immutable owner; 
    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;
    bool public paused = false;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do this");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "contract has paused");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * (10**uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value > 0, "Invalid value");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
        require(_from != address(0) && _to != address(0), "Invalid address");
        require(_value > 0, "Invalid value");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
        require(_spender != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function batchTransfer(address[] memory recipients, uint256[] memory amounts) public whenNotPaused returns (bool) {
        // 1. 检查数组长度
        require(recipients.length == amounts.length, "array length mismatch");
        // 2. 限制批量大小
        require(recipients.length <= 50, "batch size too large");
        // 3. 计算总金额
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i];
        }
        // 4. 检查余额
        require(balanceOf[msg.sender] >= totalAmount, "Insufficient balance");
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid address");
            require(amounts[i] > 0, "Invalid amount");
        }
        // 5. 执行转账
        for (uint256 i = 0; i < recipients.length; i++) {
            balanceOf[msg.sender] -= amounts[i];
            balanceOf[recipients[i]] += amounts[i];
            emit Transfer(msg.sender, recipients[i], amounts[i]);
        }
        return true;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

}