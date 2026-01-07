// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

library AdvancedMath {
    // 实现平方根（Newton-Raphson方法）
    // 牛顿-拉夫逊法
    function sqrt(uint256 n) internal pure returns (uint256) {
        // 边界条件：0 和 1 的平方根是自身
        if (n == 0 || n == 1) {
            return n;
        }

        // 初始化迭代值：初始猜测值设为 n/2（加速收敛）
        uint256 x = n / 2;
        uint256 y = (x + n / x) / 2;

        // 迭代直到收敛（y >= x 时停止，避免无限循环）
        while (y < x) {
            x = y;
            y = (x + n / x) / 2;
        }

        // 验证结果（防止因整数除法导致的误差）
        // 如果 (x+1)^2 <= n，说明x偏小，返回x+1；否则返回x
        if ((x + 1) * (x + 1) <= n) {
            return x + 1;
        }
        return x;
    }

    // 实现最大公约数
    // 欧几里得算法（辗转相除法）
    function gcd(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            return a;
        } else {
            return gcd(b, a % b);
        }
    }

    // 实现幂运算
    function power(uint256 base, uint256 exponent) internal pure returns (uint256) {
        if (exponent == 0) {
            return 1;
        }
        // 初始结果为 1
        uint256 result = 1;
        
        // 迭代拆分指数的二进制位
        while (exponent != 0) {
            // 如果指数的最低位是 1（奇数），将当前底数乘到结果中
            if (exponent & 1 == 1) {
                result = result * base;
            }
            
            // 底数平方
            base = base * base;
            // 指数除以 2（右移一位，舍弃最低位）
            exponent = exponent >> 1;
        }
        
        return result;
    }
}