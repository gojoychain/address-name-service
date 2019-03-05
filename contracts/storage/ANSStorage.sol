pragma solidity ^0.5.4;

contract IANSStorage {
    struct AddressRecord {
        bytes32[] _names;
        uint8 _limit;
    }

    mapping(address => AddressRecord) internal _addressRecords;

    function assignName(bytes32 name) external returns (bool success);
    function setLimit(uint8 newLimit) external returns (bool success);
    function resolveName(bytes32 name) external view returns (address resolvedAddress);
}
