pragma solidity ^0.5.4;

contract IANSStorage {
    mapping(bytes32 => address) private _nameRecords;
    mapping(address => uint8) private _nameMinLimits;

    function setMinLimit(address addr, uint8 limit) external returns (bool success);
    function assignName(bytes32 name) external returns (bool success);
    function resolveName(bytes32 name) external view returns (address resolvedAddress);
}
