pragma solidity ^0.5.4;

import "../ans/ANS.sol";

/// @title Address Name Service wrapper for testing
contract ANSWrapper {
    function assignName(
        address storageAddress,
        string memory name)
        public
    {
        ANS.assignName(storageAddress, name);
    }

    function setMinLimit(
        address storageAddress,
        address addr,
        uint8 minLimit)
        public
    {
        ANS.setMinLimit(storageAddress, addr, minLimit);
    }

    function resolveName(
        address storageAddress,
        string memory name)
        public
        view
        returns (address resolvedAddress)
    {
        return ANS.resolveName(storageAddress, name);
    }
}
