pragma solidity ^0.5.4;

import "../storage/IANSStorage.sol";
import "../lib/Utils.sol";

/// @title Address Name Service library
library AddressNameService {
    uint8 internal NAME_MIN_LIMIT = 8;
    uint8 internal NAME_MAX_LIMIT = 20;

    modifier validAddress(address _address) {
        require(_address != address(0), "Requires valid address.");
        _;
    }
    
    function assignName(
        address storageAddress,
        bytes32 name)
        external
        validAddress(storageAddress)
        returns (bool success)
    {
        // Define min limit
        uint8 minLimit = NAME_MIN_LIMIT;
        uint storageLimit = IANSStorage(storageAddress).getMinLimit(msg.sender);
        if (storageLimit > 0) {
            minLimit = storageLimit;
        }

        // Checks
        string memory converted = string(name);
        require(converted.length >= minLimit, "name must be longer than min length.");
        require(converted.length <= NAME_MAX_LIMIT, "name must be shorter than max length.");
        require(name[0] != 0x30 && name[1] != 0x78, "name cannot be a hex string.");
        require(IANSStorage(storageAddress).resolveName(name) == address(0), "name is already taken");

        // Convert to lowercase
        bytes32 lowerName;
        for (uint i = 0; i < name.length; i++) {
            lowerName[i] = Utils.toLower(name[i]);
        }

        // Call storage contract and assign the name
        return IANSStorage(storageAddress).assignName(lowerName);
    }

    function setMinLimit(
        address storageAddress,
        address addr,
        uint8 minLimit)
        external
        validAddress(storageAddress)
        returns (bool success)
    {
        require(minLimit >= 1 && minLimit <= NAME_MIN_LIMIT, "minLength must be between 1 and 8.");

        return IANSStorage(storageAddress).setMinLimit(addr, minLimit);
    }

    function resolveName(
        address storageAddress,
        bytes32 name)
        external
        view
        validAddress(storageAddress)
        returns (address resolvedAddress)
    {
        // Convert to lowercase
        bytes32 lowerName;
        for (uint i = 0; i < name.length; i++) {
            lowerName[i] = Utils.toLower(name[i]);
        }

        return IANSStorage(storageAddress).resolveName(lowerName);
    }
}
