pragma solidity ^0.5.4;

contract IANSStorage {
    struct NameRecord {
        bytes32[] _names;
        uint8 _limit;
    }

    mapping(bytes32 => NameRecord) internal _nameRecords;

    function addNameRecord(bytes32 name) external returns (bool success);
    function resolveName(bytes32 name) external view returns (address resolvedAddress);
}
