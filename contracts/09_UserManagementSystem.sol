// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract UserManagementSystem {
    // 定义User结构体
    struct User {
        // name, email, balance, registeredAt, exists
        string name;
        string email;
        uint256 balance;
        uint256 registeredAt;
        bool exists;
    }
    
    // 定义数据存储
    mapping(address=>User) public users;
    address[] public userAddresses;
    uint256 public userCount;
    uint256 totalAmount;
    uint256 public constant MAX_USERS = 1000;

    event Register(address userAddr, string name, string email);
    event UpdateUserInfo(address userAddr, string name, string email);
    event Deposit(address userAddr, uint256 amount);
    
    // 注册功能
    function register(string calldata _name, string calldata _email) public {
        // 检查是否已注册
        require(!users[msg.sender].exists, "user have registered");
        // 检查是否达到上限
        require(userCount < MAX_USERS, "user count is max");
        // 创建用户
        users[msg.sender] = User({
            name: _name,
            email: _email,
            balance: 0,
            registeredAt: block.timestamp,
            exists: true
        });
        // 添加到列表
        userAddresses.push(msg.sender);
        // 更新计数
        userCount++;

        emit Register(msg.sender, _name, _email);
    }

    // 更新用户信息
    function updateUserInfo(string calldata _name, string calldata _email) public {
        require(users[msg.sender].exists, "user not registered");
        users[msg.sender].name = _name;
        users[msg.sender].email = _email;
        emit UpdateUserInfo(msg.sender, _name, _email);
    }

    // 存款
    function deposit(uint256 _amount) public payable {
        require(users[msg.sender].exists, "user not registered");
        require(msg.value == _amount, "amount mismatch");
        users[msg.sender].balance += _amount;
        totalAmount += _amount;
        emit Deposit(msg.sender, _amount);
    }

    // 查询用户信息
    function queryUserInfo(address userAddr) public view returns(User memory) {
        require(users[userAddr].exists, "user not registered");
        return users[userAddr];
    }

    // 获取所有用户列表
    function queryAllUsers() public view returns(User[] memory) {
        User[] memory userList = new User[](userCount);
        for (uint i = 0; i < userCount; i++) {
            userList[i] = users[userAddresses[i]];
        }
        return userList;
    }

    // 分批查询用户
    function queryUsersByPage(uint pageNum, uint pageSize) public view returns(uint, uint, uint, uint, User[] memory) {
        require(pageNum > 0, "Invalid pageNum");
        require(pageSize > 0, "Invalid pageSize");
        uint start = (pageNum - 1) * pageSize;
        uint end = start + pageSize;
        if (end > userCount) {
            end = userCount;
        }
        uint totalPages = (userCount + pageSize - 1) / pageSize;
        User[] memory userList = new User[](end - start);
        for (uint i = start; i < end; i++) {
            userList[i - start] = users[userAddresses[i]];
        }
        
        return (pageNum, pageSize, userCount, totalPages, userList);
    }
    
}