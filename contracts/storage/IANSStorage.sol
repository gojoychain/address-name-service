pragma solidity ^0.5.4;

/// @title Address Name Service Storage interface
contract IANSStorage {
    event NameAssigned(string indexed name, address indexed addr);

    function assignName(string calldata name) external returns (bool success);
    function setMinLimit(address addr, uint8 limit) external returns (bool success);
    function resolveName(string calldata name) external view returns (address resolved);
    function getMinLimit(address addr) external view returns (uint8 limit);
}
