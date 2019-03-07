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

    address internal _storageAddress;

    modifier validStorageAddress() {
        require(_storageAddress != address(0), "Storage address has not be set.");
        _;
    }

    /// @param owner Owner of the contract.
    constructor(address owner) Ownable(owner) public validAddress(owner) {
    }

    /// @dev Sets the storage address and enables all other functions.
    ///      All other functions rely on a valid storage contract address
    ///      so this function needs to be called first.
    /// @param addr Address of the storage contract.
    function setStorageAddress(
        address addr) 
        external 
        onlyOwner
        validAddress(addr) 
    {
        require(_storageAddress == address(0), "Storage address already set.");
        _storageAddress = addr;
    }

    function assignName(
        string calldata name)
        external
        validStorageAddress
        returns (bool success)
    {
        // Define min limit
        uint8 minLimit = NAME_MIN_LIMIT;
        uint8 storageLimit = IANSStorage(_storageAddress).getMinLimit(msg.sender);
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
        require(IANSStorage(_storageAddress).resolveName(lowerName) == address(0), "name is already taken");

        // Call storage contract and assign the name
        return IANSStorage(_storageAddress).assignName(msg.sender, lowerName);
    }

    function setMinLimit(
        address addr,
        uint8 minLimit)
        external
        onlyOwner
        validStorageAddress
        returns (bool success)
    {
        require(minLimit >= 1 && minLimit <= NAME_MIN_LIMIT, "minLength must be between 1 and 8.");

        return IANSStorage(_storageAddress).setMinLimit(addr, minLimit);
    }

    function transferStorageOwnership(
        address newOwner) 
        external 
        onlyOwner 
        validStorageAddress 
        returns (bool success) 
    {
        IANSStorage(_storageAddress).transferOwnership(newOwner);
        return true;
    }

    function renounceStorageOwnership() 
        external 
        onlyOwner 
        validStorageAddress 
        returns (bool success) 
    {
        IANSStorage(_storageAddress).renounceOwnership();
        return true;
    }

    function resolveName(
        string calldata name)
        external
        view
        validStorageAddress
        returns (address resolvedAddress)
    {
        // Convert to lowercase
        bytes memory nameBytes = name.toBytes();
        nameBytes = nameBytes.toLower();
        string memory lowerName = nameBytes.toString();

        return IANSStorage(_storageAddress).resolveName(lowerName);
    }
}
