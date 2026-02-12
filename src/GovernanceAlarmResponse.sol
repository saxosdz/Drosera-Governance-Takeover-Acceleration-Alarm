    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    contract GovernanceAlarmResponse {

event GovernanceAttackAlert(
    address indexed suspiciousAddress,
    uint256 votingPowerPercent
);

function emergencyGovernanceAlert(
    address suspect,
    uint256 percent
  ) external {
       emit GovernanceAttackAlert(suspect, percent);
    }
}
