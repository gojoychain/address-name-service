pragma solidity ^0.5.4;

import "./IANSStorage.sol";
import "../lib/Ownable.sol";

/// @title Address Name Service Storage contract
contract ANSStorage is IANSStorage, Ownable {
    function assignName(
        bytes32 name) 
        external 
        onlyOwner
        returns (bool success) 
    {
        _nameRecords[name] = msg.sender;
        return true;
    }

    function setMinLimit(
        address addr,
        uint8 limit)
        external
        onlyOwner
        returns (bool success)
    {
        _nameMinLimits[addr] = limit;
        return true;
    }

    function resolveName(
        bytes32 name) 
        external 
        view 
        returns (address resolvedAddress)
    {
        return _nameRecords[name];
    }

    function getMinLimit(
        address addr) 
        external 
        view 
        returns (uint8 limit) 
    {
        return _nameMinLimits[addr];
    }
}
