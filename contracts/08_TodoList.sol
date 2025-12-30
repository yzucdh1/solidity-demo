// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract TodoList {
    struct Todo {
        string task;
        bool completed;
        uint256 timestamp;
    }

    mapping(address=>Todo[]) private todoList;
    uint public constant MAX_TODOS = 100;

    function addTodo(string calldata task) public {
        Todo[] storage todos = todoList[msg.sender];
        require(todos.length < MAX_TODOS, "every user most have 100 todos");
        Todo memory todo = Todo(task, false, block.timestamp);
        todos.push(todo);
    }

    function completeTodo(uint index) public {
        Todo[] storage todos = todoList[msg.sender];
        require(index < todos.length, "index out of bounds");
        require(!todos[index].completed, "has completed");
        todos[index].completed = true;
    }

    function deleteTodo(uint index) public {
        Todo[] storage todos = todoList[msg.sender];
        require(index < todos.length, "index out of bounds");
        for (uint i = index; i < todos.length - 1; i++) {
            todos[i] = todos[i + 1];
        }
        todos.pop();
    }

    function getAllTodos() public view returns(Todo[] memory) {
        Todo[] memory todos = todoList[msg.sender];
        return todos;
    }

    function getAllCompletedTodos() public view returns(Todo[] memory) {
        Todo[] memory todos = todoList[msg.sender];
        uint len = todos.length;
        uint count = 0;
        for (uint i = 0; i < len; i++) {
            if (todos[i].completed) {
                count++;
            }
        }

        Todo[] memory results = new Todo[](count);
        uint index = 0;
        for (uint i = 0; i < len; i++) {
            if (todos[i].completed) {
                results[index] = todos[i];
                index++;
            }
        }

        return results;
    }
    
}