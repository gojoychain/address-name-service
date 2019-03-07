pragma solidity ^0.5.4;

import "./IANSStorage.sol";
import "../lib/Ownable.sol";

/// @title Address Name Service Storage contract
contract ANSStorage is IANSStorage, Ownable {
    mapping(string => address) private _nameRecords;
    mapping(address => uint8) private _nameMinLimits;

    /// @param owner Owner of the contract.
    constructor(address owner) Ownable(owner) public validAddress(owner) {
    }

    /// @dev Note the validation of the name should happen in the library contract.
    ///      Only the owner of this contract can call this.
    /// @param addr Address to set the name for.
    /// @param name Name to add a name record for. 
    /// @return True if the assignment succeeds.
    function assignName(
        address addr,
        string calldata name)
        external 
        onlyOwner 
        validAddress(addr)
        returns (bool success) 
    {
        _nameRecords[name] = addr;
        emit NameAssigned(name, addr);
        return true;
    }

    /// @dev Validation should happen in the library contract.
    ///      Only the owner of this contract can call this.
    /// @param addr Address to set the limit on.
    /// @param limit Minimum length of any future added name records.
    /// @return True if setting the limit succeeds.
    function setMinLimit(
        address addr, 
        uint8 limit) 
        external 
        onlyOwner 
        validAddress(addr)
        returns (bool success) 
    {
        _nameMinLimits[addr] = limit;
        emit NameLimitSet(addr, limit);
        return true;
    }

    /// @param name Name to resolve to an address.
    /// @return Address associated with the name.
    function resolveName(
        string calldata name) 
        external 
        view 
        returns (address resolved) 
    {
        return _nameRecords[name];
    }

    /// @param addr Address to find the min limit for.
    /// @return Min limit of name length.
    function getMinLimit(
        address addr) 
        external 
        view 
        returns (uint8 limit) 
    {
        return _nameMinLimits[addr];
    }
}
