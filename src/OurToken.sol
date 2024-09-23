// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 Use these links to make things easier :
 https://docs.openzeppelin.com/contracts/4.x/
 forge install OpenZeppelin/openzeppelin-contracts --no-commit
 */
contract OurToken is ERC20 {
    constructor(uint256 _initalSuppy) ERC20("OurToken", "OT") {
        _mint(msg.sender, _initalSuppy);
    }
}
