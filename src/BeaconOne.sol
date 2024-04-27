// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface IBeaconOne {
    function addToA(uint256 _add) external;
    function getA() external view returns (uint256);
}

contract BeaconOne is IBeaconOne {

    uint256 a;

    function  addToA(uint256 _add)  external {
        a += _add;
    }

    function getA() public view  returns (uint256) {
        return a; 
    }

} 