pragma solidity ^0.5.4;

import "../ans/ANS.sol";

/// @title Address Name Service wrapper for testing
contract ANSWrapper {
    function assignName(
        address ansAddress,
        address storageAddress,
        bytes32 name)
        external
        returns (bool success)
    {
        (bool res, bytes memory data) = ansAddress.delegatecall(
            abi.encodePacked(
                bytes4(keccak256("assignName(address,bytes32)")), 
                storageAddress, 
                name
            )
        );
        return true;
        // return ANS(ansAddress).assignName(storageAddress, name);
    }

    function setMinLimit(
        address ansAddress,
        address storageAddress,
        address addr,
        uint8 minLimit)
        external
        returns (bool success)
    {
        (bool res, bytes memory data) = ansAddress.delegatecall(
            abi.encodePacked(
                bytes4(keccak256("setMinLimit(address,address,uint8)")), 
                storageAddress, 
                addr,
                minLimit
            )
        );
        return true;
        // return ANS(ansAddress).setMinLimit(storageAddress, addr, minLimit);
    }

    function resolveName(
        address ansAddress,
        address storageAddress,
        bytes32 name)
        external
        view
        returns (address resolvedAddress)
    {
        (bool res, bytes memory data) = ansAddress.staticcall(
            abi.encodePacked(
                bytes4(keccak256("resolveName(address,bytes32)")), 
                storageAddress, 
                name
            )
        );

        address resolved;
        assembly {
            resolved := mload(add(data, 20))
        } 

        return resolved;
        // return ANS(ansAddress).resolveName(storageAddress, name);
    }
}
