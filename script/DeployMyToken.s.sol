// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {MyToken} from "../src/MyToken.sol";
import {Script} from "forge-std/Script.sol";

contract CodeConstants {
    string constant TOKEN_NAME = "My Token";
    string constant TOKEN_SYMBOL = "MT";
    uint256 constant INITIAL_SUPPLY = 100000 ether;
}

contract DeployMyToken is CodeConstants, Script {
    function run() external returns (MyToken) {
        return deployMyToken();
    }

    function deployMyToken() public returns (MyToken) {
        vm.startBroadcast();
        MyToken myToken = new MyToken(TOKEN_NAME, TOKEN_SYMBOL, INITIAL_SUPPLY);
        vm.stopBroadcast();
        return myToken;
    }
}
