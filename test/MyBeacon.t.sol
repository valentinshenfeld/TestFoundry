// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {BeaconOne, IBeaconOne}  from "../src/BeaconOne.sol";
import {BeaconTwo, IBeaconTwo}  from "../src/BeaconTwo.sol";
import {MyBeaconProxy}  from "../src/MyBeaconProxy.sol";
import {MyEggProxy}  from "../src/MyEggProxy.sol";
import {MyBeacon}  from "../src/MyBeacon.sol";

contract MyBeaconTest is Test{
    BeaconOne beaconOne;
    BeaconTwo beaconTwo;
    MyBeacon beacon;
    address beaconProxy;
    address eggProxy;
    address alice = makeAddr("alice");

    function setUp() external {
        beaconOne = new BeaconOne();
        beacon = new MyBeacon(address(beaconOne), alice);

        beaconProxy = address(new MyBeaconProxy(address(beacon)));
        eggProxy = address(new MyEggProxy(address(beacon)));

    }

    function test_implementation() external view {
        assertEq(beacon.implementation(), address(beaconOne));
        
    }

    function test_v1()  external {
        populateAndTestV1Data();
        
    }

    function populateAndTestV1Data()  private {
        IBeaconOne proxiBeaconV1 = IBeaconOne(beaconProxy);
        proxiBeaconV1.addToA(3);
        assertEq(proxiBeaconV1.getA(), 3);

        IBeaconOne proxiEggV1 = IBeaconOne(eggProxy);
        proxiEggV1.addToA(12);
        assertEq(proxiEggV1.getA(), 12);

        assertEq(proxiBeaconV1.getA(), 3);
    }
    function test_upgrade()  external {

        BeaconTwo beaconV2 = new BeaconTwo();
        populateAndTestV1Data();

        vm.prank(alice);
        beacon.upgradeTo(address(beaconV2));

        IBeaconTwo proxiBeaconV2 = IBeaconTwo(beaconProxy);
        proxiBeaconV2.multiplyA();
        assertEq(proxiBeaconV2.getA(), 6);

        IBeaconTwo proxiEggV2 = IBeaconTwo(eggProxy);
        proxiEggV2.multiplyA();
        assertEq(proxiEggV2.getA(), 24);

        
    }
}