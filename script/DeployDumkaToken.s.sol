//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/DumkaToken.sol";

contract DeployDumkaToken is Script {
    function run() external {
        vm.startBroadcast();
        new DumkaToken(
            "DumkaToken",
            "DUM",
            1_000_000
            );
        vm.stopBroadcast();
    }
}