// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGovToken {
    function totalSupply() external view returns (uint256);
    function balanceOf(address user) external view returns (uint256);
}

contract GovernanceTakeoverAlarmTrap {

IGovToken public token;
address public monitoredAddress;

uint256 public constant THRESHOLD_PERCENT = 25;

constructor(address _token, address _monitored) {
    token = IGovToken(_token);
    monitoredAddress = _monitored;
}

function shouldRespond() external view returns (bool) {

    uint256 total = token.totalSupply();
    uint256 balance = token.balanceOf(monitoredAddress);

    uint256 percent = (balance * 100) / total;

    if (percent >= THRESHOLD_PERCENT) {
        return true;
        }

        return false;
    }
}
