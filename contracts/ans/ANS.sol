pragma solidity ^0.5.4;

import "../storage/IANSStorage.sol";
import "../lib/Ownable.sol";
import "../lib/Utils.sol";

/// @title Address Name Service contract
contract ANS is Ownable {
    using Utils for bytes;
    using Utils for string;

    uint8 constant internal NAME_MIN_LIMIT = 8;
    uint8 constant internal NAME_MAX_LIMIT = 20;

    /// @param owner Owner of the contract.
    constructor(address owner) Ownable(owner) public validAddress(owner) {
    }

    function assignName(
        address storageAddress,
        string memory name)
        external
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
        external
        onlyOwner
        validAddress(storageAddress)
        returns (bool success)
    {
        require(minLimit >= 1 && minLimit <= NAME_MIN_LIMIT, "minLength must be between 1 and 8.");

        return IANSStorage(storageAddress).setMinLimit(addr, minLimit);
    }

    function resolveName(
        address storageAddress,
        string memory name)
        external
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
