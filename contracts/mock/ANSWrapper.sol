pragma solidity ^0.5.4;

import "../ans/ANS.sol";

/// @title Address Name Service wrapper for testing
contract ANSWrapper {
    function assignName(
        address ansAddress,
        address storageAddress,
        bytes32 name)
        public
    {
        ANS.assignName(storageAddress, name);

        // (bool success,) = ansAddress.delegatecall(
        //     abi.encodePacked(
        //         bytes4(keccak256("assignName(address,bytes32)")), 
        //         storageAddress, 
        //         name
        //     )
        // );
        // if (!success) revert("assignName failed.");
    }

    function setMinLimit(
        address ansAddress,
        address storageAddress,
        address addr,
        uint8 minLimit)
        public
    {
        ANS.setMinLimit(storageAddress, addr, minLimit);

        // (bool success,) = ansAddress.delegatecall(
        //     abi.encodePacked(
        //         bytes4(keccak256("setMinLimit(address,address,uint8)")), 
        //         storageAddress, 
        //         addr,
        //         minLimit
        //     )
        // );
        // if (!success) revert("setMinLimit failed.");
    }

    function resolveName(
        address ansAddress,
        address storageAddress,
        bytes32 name)
        public
        view
        returns (address resolvedAddress)
    {
        return ANS.resolveName(storageAddress, name);

        // (bool success, bytes memory data) = ansAddress.staticcall(
        //     abi.encodePacked(
        //         bytes4(keccak256("resolveName(address,bytes32)")), 
        //         storageAddress, 
        //         name
        //     )
        // );
        // if (!success) revert("resolveName failed.");

        // address resolved;
        // assembly {
        //     resolved := mload(add(data, 20))
        // } 
        // return resolved;
    }
}
