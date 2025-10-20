// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployMyToken, CodeConstants} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";
import {Test} from "forge-std/Test.sol";

contract MyTokenTest is CodeConstants, Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    uint256 initialUserBalance = 10000 ether;

    function setUp() external {
        deployer = new DeployMyToken();
        myToken = deployer.run();
    }

    function testMyTokenMintedInitialSupplyToDeployer() external view {
        assertEq(myToken.balanceOf(msg.sender), INITIAL_SUPPLY);
    }

    function testMyTokenNameWasSetCorrectly() external view {
        assertEq(myToken.name(), TOKEN_NAME);
    }

    function testMyTokenSymbolWasSetCorrectly() external view {
        assertEq(myToken.symbol(), TOKEN_SYMBOL);
    }

    modifier usersFunded() {
        vm.startPrank(msg.sender);
        bool success1 = myToken.transfer(user1, initialUserBalance);
        assert(success1);
        bool success2 = myToken.transfer(user2, initialUserBalance);
        assert(success2);
        vm.stopPrank();
        _;
    }

    function testTransferWorksCorrectly() external usersFunded {
        assertEq(myToken.balanceOf(user1), initialUserBalance);
        assertEq(myToken.balanceOf(user2), initialUserBalance);
    }

    function testAllowanceWorksCorrectly() external usersFunded {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(user1);
        myToken.approve(user2, initialAllowance);
        vm.prank(user2);
        bool success = myToken.transferFrom(user1, user2, transferAmount);
        assert(success);
        assertEq(
            myToken.allowance(user1, user2),
            (initialAllowance - transferAmount)
        );
    }

    function testTransferFromWorksCorrectly() external usersFunded {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(user1);
        myToken.approve(user2, initialAllowance);
        vm.prank(user2);
        bool success = myToken.transferFrom(user1, user2, transferAmount);
        assert(success);
        assertEq(
            myToken.balanceOf(user2),
            (initialUserBalance + transferAmount)
        );
        assertEq(
            myToken.balanceOf(user1),
            (initialUserBalance - transferAmount)
        );
    }
}
