pragma solidity ^0.5.4;

import "../ans/ANS.sol";
import "../lib/Utils.sol";

/// @title Address Name Service wrapper for testing
contract ANSWrapper {
    event Test1(uint256 indexed length);
    event Test2(bytes32 indexed b);

    function test(string memory name) public pure returns (uint256) {
        bytes memory b = bytes(name);
        return b.length;
    }

    function assignName(
        address ansAddress,
        address storageAddress,
        string memory name)
        public
    {
        // bytes32 testStr = "a";
        // emit Test2(testStr);
        // bytes memory byteStr = bytes(testStr);

        // string memory str = Utils.toString(name);
        // emit Test1(Utils.length(str));

        // uint len = 0;
        // for (uint i = 0; i < byteStr.length; i++) {
        //     if (byteStr[i] != 0) {
        //         len++;
        //     }
        // }
        // emit Test1(len);

        // ANS.assignName(storageAddress, name);
    }

    function setMinLimit(
        address ansAddress,
        address storageAddress,
        address addr,
        uint8 minLimit)
        public
    {
        ANS.setMinLimit(storageAddress, addr, minLimit);
    }

    function resolveName(
        address ansAddress,
        address storageAddress,
        string memory name)
        public
        view
        returns (address resolvedAddress)
    {
        return ANS.resolveName(storageAddress, name);
    }
}
