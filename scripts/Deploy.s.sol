// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovernanceTakeoverAlarmTrap.sol";
import "../src/GovernanceAlarmResponse.sol";
import "../src/MockGovernanceToken.sol";

contract Deploy is Script {

function run() external {

    vm.startBroadcast();

    MockGovernanceToken token = new MockGovernanceToken();

    GovernanceAlarmResponse response = new GovernanceAlarmResponse();

    GovernanceTakeoverAlarmTrap trap =
        new GovernanceTakeoverAlarmTrap(
            address(token),
            msg.sender
        );

    vm.stopBroadcast();
  }
}
