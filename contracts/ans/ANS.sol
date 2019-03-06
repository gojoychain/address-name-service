pragma solidity ^0.5.4;

import "../storage/IANSStorage.sol";
import "../lib/Utils.sol";

/// @title Address Name Service library
library ANS {
    using Utils for bytes;
    using Utils for string;

    uint8 constant internal NAME_MIN_LIMIT = 8;
    uint8 constant internal NAME_MAX_LIMIT = 20;

    modifier validAddress(address _address) {
        require(_address != address(0), "Requires valid address.");
        _;
    }
    
    function assignName(
        address storageAddress,
        string memory name)
        public
        validAddress(storageAddress)
        returns (bool success)
    {
        // Define min limit
        uint8 minLimit = NAME_MIN_LIMIT;
        uint8 storageLimit = IANSStorage(storageAddress).getMinLimit(msg.sender);
        if (storageLimit > 0) {
            minLimit = storageLimit;
        }
        
        // Convert to bytes to check length and characters
        bytes memory nameBytes = name.toBytes();
        // Convert to lowercase
        nameBytes = nameBytes.toLower();
        string memory lowerName = nameBytes.toString();

        // Checks
        require(nameBytes.length >= minLimit, "name is too short.");
        require(nameBytes.length <= NAME_MAX_LIMIT, "name is too long.");
        require(nameBytes[0] != 0x30 && nameBytes[1] != 0x78, "name cannot be a hex string.");
        require(IANSStorage(storageAddress).resolveName(lowerName) == address(0), "name is already taken");

        // Call storage contract and assign the name
        return IANSStorage(storageAddress).assignName(lowerName);
    }

    function setMinLimit(
        address storageAddress,
        address addr,
        uint8 minLimit)
        public
        validAddress(storageAddress)
        returns (bool success)
    {
        require(minLimit >= 1 && minLimit <= NAME_MIN_LIMIT, "minLength must be between 1 and 8.");

        return IANSStorage(storageAddress).setMinLimit(addr, minLimit);
    }

    function resolveName(
        address storageAddress,
        string memory name)
        public
        view
        validAddress(storageAddress)
        returns (address resolvedAddress)
    {
        // Convert to lowercase
        bytes memory nameBytes = name.toBytes();
        nameBytes = nameBytes.toLower();
        string memory lowerName = nameBytes.toString();

        return IANSStorage(storageAddress).resolveName(lowerName);
    }
}
