// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract TokenSwap {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public constant SWAP_RATE = 1;

    event Swap(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function swap(uint256 amountA) public {
        require(amountA > 0, "Invalid amount");
        require(tokenA.balanceOf(msg.sender) >= amountA, "Insufficient balance");
        uint256 amountB = amountA * SWAP_RATE;
        require(tokenB.balanceOf(address(this)) >= amountB, "Insufficient balance");

        require(tokenA.transferFrom(msg.sender, address(this), amountA), "transferA failed");
        require(tokenB.transfer(msg.sender, amountB), "transferB failed");
        emit Swap(msg.sender, address(tokenA), address(tokenB), amountA, amountB);
    }
}