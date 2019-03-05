pragma solidity ^0.5.4;

/// @title Address Name Service Storage interface
contract IANSStorage {
    mapping(bytes32 => address) private _nameRecords;
    mapping(address => uint8) private _nameMinLimits;

    function assignName(bytes32 name) external returns (bool success);
    function setMinLimit(address addr, uint8 limit) external returns (bool success);
    function resolveName(bytes32 name) external view returns (address resolvedAddress);
    function getMinLimit(address addr) external view returns (uint8 limit);
}
