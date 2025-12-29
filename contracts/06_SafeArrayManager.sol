// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SafeArrayManager {
    uint[] public data;
    uint public constant MAX_SIZE = 100;

    // 1. 安全添加
    function safePush(uint value) public {
        // 检查大小限制
        require(data.length < MAX_SIZE, "array is full");
        // 添加元素
        data.push(value);
    }
    
    // 2. 保序删除
    function removeOrdered(uint index) public {
        // 检查索引
        uint len = data.length;
        require(index >=0 && index < len, "Invalid index");
        // 移动元素
        for (uint i = index; i < len-1; i++) {
            data[i] = data[i+1];
        }
        // pop最后元素
        data.pop();
    }
    
    // 3. 快速删除
    function removeUnordered(uint index) public {
        // 检查索引
        uint len = data.length;
        require(index >=0 && index < len, "Invalid index");
        // 替换为最后元素
        data[index] = data[len-1];
        // pop
        data.pop();
    }
    
    // 4. 分批求和
    function sumRange(uint start, uint end) public view returns (uint) {
        // 检查范围
        uint len = data.length;
        require(start <= end, "start must less than end");
        require(end < len, "end must less than data length");
        // 计算总和
        uint sum = 0;
        for (uint i = start; i < end; i++) {
            sum += data[i];
        }
        return sum;
    }
    
    // 5. 查找元素
    function findElement(uint value) public view returns (bool, uint) {
        // 遍历查找
        uint len = data.length;
        for (uint i = 0; i < len; i++) {
            if(data[i] == value) {
                return (true, i);
            }
        }
        // 返回是否找到和索引
        return (false, 0);
    }
    
    // 6. 获取所有元素
    function getAll() public view returns (uint[] memory) {
        // 返回整个数组
        return data;
    }

}