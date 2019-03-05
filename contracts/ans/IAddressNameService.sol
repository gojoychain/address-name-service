pragma solidity ^0.5.4;

/// @title Address Name Service interface
contract IAddressNameService {
    uint8 internal NAME_MIN_LIMIT = 8;
    uint8 internal NAME_MAX_LIMIT = 20;

    mapping(bytes32 => address) internal _nameRecords;
    mapping(address => uint8) internal _nameMinLimits;

    function setMinLimit(address addr, uint8 limit) external returns (bool success);
    function assignName(bytes32 name) external returns (bool success);
    function resolveName(bytes32 name) external view returns (address resolvedAddress);
}
