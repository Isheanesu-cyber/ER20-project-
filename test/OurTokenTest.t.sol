// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "src/OurToken.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourtoken;
    DeployOurToken public deployourtoken;

    address public bob = makeAddr("bob");
    address public alice = makeAddr("alice");
    address public charlie = makeAddr("charlie");

    uint256 public STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployourtoken = new DeployOurToken();
        ourtoken = deployourtoken.run();

        vm.prank(msg.sender);
        ourtoken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourtoken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 500 ether;

        // Bob approves approves Alice to spend tokens on his behalf
        vm.prank(bob);
        ourtoken.approve(alice, initialAllowance);

        uint256 transferAmount = 10 ether;
        vm.prank(alice);
        ourtoken.transferFrom(bob, alice, transferAmount);

        assertEq(ourtoken.balanceOf(alice), transferAmount);
        assertEq(ourtoken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransferZeroTokens() public {
        vm.startPrank(bob);
        bool success = ourtoken.transfer(charlie, 0);
        assertTrue(success);
        assertEq(ourtoken.balanceOf(charlie), 0);
        vm.stopPrank();
    }

    function testInsufficientFunds() public {
        vm.startPrank(bob);
        uint256 insufficientAmount = 2000 ether;
        vm.expectRevert();
        ourtoken.transfer(charlie, insufficientAmount);
        vm.stopPrank();
    }

    function testApproveAndTransferMultipleTimes() public {
        uint256 initialApproval = 50 ether;
        uint256 transferAmount = 10 ether;

        vm.startPrank(bob);
        ourtoken.approve(alice, initialApproval);

        vm.startPrank(alice);
        for (uint256 i; i < 5; ++i) {
            ourtoken.transferFrom(bob, alice, transferAmount);
        }
        vm.stopPrank();

        assertEq(ourtoken.balanceOf(alice), 50 ether);
        assertEq(ourtoken.balanceOf(bob), STARTING_BALANCE - 50 ether);
        vm.stopPrank();
    }

    // function testIncreaseAllowance() public {
    //     uint256 initialApproval = 50 ether;
    //     uint256 increaseAmount = 25 ether;

    //     vm.startPrank(bob);
    //     ourtoken.approve(alice, initialApproval);
    //     ourtoken.increaseAllowance(alice, increaseAmount);
    //     assertEq(
    //         ourtoken.allowance(bob, alice),
    //         initialApproval + increaseAmount
    //     );
    //     vm.stopPrank();
    // }

    // function testDecreaseAllowance() public {
    //     uint256 initialApproval = 75 ether;
    //     uint256 decreaseAmount = 30 ether;

    //     vm.startPrank(bob);
    //     ourtoken.approve(alice, initialApproval);
    //     ourtoken.decreaseAllowance(alice, decreaseAmount);
    //     assertEq(
    //         ourtoken.allowance(bob, alice),
    //         initialApproval - decreaseAmount
    //     );
    //     vm.stopPrank();
    // }
}
