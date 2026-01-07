// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract OpenZeppelinDemo is ERC20, Ownable, ERC20Burnable {

    constructor(uint256 _initialSupply) Ownable(msg.sender) ERC20("My Token", "MTT") {
        _mint(msg.sender, _initialSupply * (10 ** decimals()));
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}