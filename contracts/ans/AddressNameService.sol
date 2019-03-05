pragma solidity ^0.5.4;

import "./IAddressNameService.sol";
import "../lib/Utils.sol";

/// @title Address Name Service library
library AddressNameService is IAddressNameService {
    function setMinLimit(
        address addr,
        uint8 minLimit)
        external 
        onlyOwner
        validAddress
        returns (bool success) 
    {
        require(
            minLimit >= 1 && minLimit <= NAME_MIN_LIMIT, 
            "minLength must be between 1 and 8."
        );

        _nameMinLimits[addr] = minLength;
    }

    function assignName(
        bytes32 name) 
        external 
        returns (bool success) 
    {
        // Set min limit
        uint8 minLimit = NAME_MIN_LIMIT;
        if (_nameMinLimits[msg.sender] > 0) {
            minLimit = _nameMinLimits[msg.sender];
        }

        // Checks
        string memory converted = string(name);
        require(converted.length >= minLimit, "name must be longer than min length.");
        require(converted.length <= NAME_MAX_LIMIT, "name must be shorter than max length.");
        require(name[0] != 0x30 && name[1] != 0x78, "name cannot be a hex string.");
        require(_nameRecords[name] == address(0), "name is already taken");

        // Convert to lowercase
        bytes32 lowerName;
        for (uint i = 0; i < name.length; i++) {
            lowerName[i] = Utils.toLower(name[i]);
        }

        // Map name to sender's address
        _nameRecords[lowerName] = msg.sender;
    }
    
    function resolveName(
        bytes32 name) 
        external 
        view 
        returns (address resolvedAddress) 
    {
        return _nameRecords[name];
    }
}
