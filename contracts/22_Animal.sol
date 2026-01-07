// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

abstract contract Animal {
    function makeSound() virtual public;

    function eat() public virtual {
        
    }
}

contract Dog is Animal {
    function makeSound() public override {

    }
}

contract Cat is Animal {
    function makeSound() public override {
        
    }
}