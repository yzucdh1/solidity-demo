// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract OrderSystem {
    enum OrderStatus{Created, Paided, Shipped, Completed, Cancelled}

    struct Order {
        address buyer;
        uint256 amount;
        OrderStatus status;
        uint256 createdAt;
    }

    mapping(uint256=>Order) public orders;
    uint256 public orderCount;

    event OrderCreated(uint256 indexed orderId, address indexed buyer, uint256 amount, uint256 createdAt);
    event OrderPaided(uint256 indexed orderId, address indexed buyer, uint256 amount, uint256 paidedAt);
    event OrderShipped(uint256 indexed orderId, uint256 shipAt);
    event OrderCompleted(uint256 indexed orderId, address indexed buyer, uint256 completeAt);
    event OrderCancelled(uint256 indexed orderId, address indexed buyer, string reason, uint256 cancelledAt);

    function orderCreate() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        uint256 orderId = orderCount++;
        orders[orderId] = Order({
            buyer: msg.sender,
            amount: msg.value,
            status: OrderStatus.Created,
            createdAt: block.timestamp
        });
        emit OrderCreated(orderId, msg.sender, msg.value, block.timestamp);
    }

    function orderPaid(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.buyer == msg.sender, "You are not the buyer of this order");
        require(order.status == OrderStatus.Created, "Order is not in the created state");
        order.status = OrderStatus.Paided;
        emit OrderPaided(orderId, msg.sender, order.amount, block.timestamp);
    }

    function orderShip(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.status == OrderStatus.Paided, "Order is not in the paided state");
        order.status = OrderStatus.Shipped;
        emit OrderShipped(orderId, block.timestamp);
    }

    function orderComplete(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.buyer == msg.sender, "You are not the buyer of this order");
        require(order.status == OrderStatus.Shipped, "Order is not in the shipped state");
        order.status = OrderStatus.Completed;
        emit OrderCompleted(orderId, msg.sender, block.timestamp);
    }

    function orderCancel(uint256 orderId, string memory reason) public {
        Order storage order = orders[orderId];
        require(order.buyer == msg.sender, "You are not the buyer of this order");
        require(order.status == OrderStatus.Created || order.status == OrderStatus.Paided, "Order can not cancel");
        order.status = OrderStatus.Cancelled;
        if (order.status == OrderStatus.Paided) {
            (bool success, ) = payable(msg.sender).call{value: order.amount}("");
            require(success, "Refund failed");
        }
        emit OrderCancelled(orderId, msg.sender, reason, block.timestamp);
    }
}