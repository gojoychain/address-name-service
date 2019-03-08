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
        require(_storageAddress != address(0), "Storage address not set.");
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

    /// @dev Calls the storage contract and assigns the name for the msg.sender.
    /// @param name Name to add a name record for. 
    /// @return True if the assignment succeeds.
    function assignName(
        string calldata name)
        external
        validStorageAddress
        returns (bool success)
    {
        // Define min limit
        uint8 storageLimit = IANSStorage(_storageAddress).getMinLimit(msg.sender);
        uint8 minLimit;
        if (storageLimit > 0) {
            minLimit = storageLimit;
        } else {
            minLimit = NAME_MIN_LIMIT;
        }
        
        // Convert to bytes to check length and characters
        bytes memory nameBytes = name.toBytes();
        // Convert to lowercase
        nameBytes = nameBytes.toLower();
        string memory lowerName = nameBytes.toString();

        // Checks
        require(nameBytes.length >= minLimit, "name is too short.");
        require(nameBytes.length <= NAME_MAX_LIMIT, "name is too long.");
        require(nameBytes.validateNotHex(), "name cannot be a hex string.");
        require(
            nameBytes.validateLettersAndNumbers(), 
            "name contains invalid characters."
        );
        require(
            IANSStorage(_storageAddress).resolveName(lowerName) == address(0), 
            "name is already taken."
        );

        // Call storage contract and assign the name
        return IANSStorage(_storageAddress).assignName(msg.sender, lowerName);
    }

    /// @dev Sets the name min limit for a given address.
    /// @param addr Address to set the limit on.
    /// @param minLimit Minimum length of any future added name records.
    /// @return True if setting the limit succeeds.
    function setMinLimit(
        address addr,
        uint8 minLimit)
        external
        onlyOwner
        validStorageAddress
        returns (bool success)
    {
        require(
            minLimit >= 1 && minLimit <= NAME_MIN_LIMIT, 
            "minLength must be between 1 and 8."
        );

        return IANSStorage(_storageAddress).setMinLimit(addr, minLimit);
    }

    /// @dev Changes the storage owner.
    ///      Changing it will remove the permissions from this contract. 
    ///      The new owner should be another ANS contract.
    ///      ONLY FOR PURPOSES OF UPGRADING THE ANS CONTRACT!
    /// @param newOwner New owner of the storage contract.
    /// @return True if changing ownership succeeds.
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

    /// @dev Renounces the storage owner.
    ///      Renouncing the owner will render the storage contract useless.
    ///      ONLY FOR PURPOSES OF SELF-DESTRUCTING THE CONTRACT!
    /// @return True if renouncing ownership succeeds.
    function renounceStorageOwnership() 
        external 
        onlyOwner 
        validStorageAddress 
        returns (bool success) 
    {
        IANSStorage(_storageAddress).renounceOwnership();
        return true;
    }

    /// @param name Name to resolve to an address.
    /// @return Address associated with the name.
    function resolveName(
        string calldata name)
        external
        view
        validStorageAddress
        returns (address resolved)
    {
        // Convert to lowercase
        bytes memory nameBytes = name.toBytes();
        nameBytes = nameBytes.toLower();
        string memory lowerName = nameBytes.toString();

        return IANSStorage(_storageAddress).resolveName(lowerName);
    }

    /// @param addr Address to find the min limit for.
    /// @return Min limit of name length.
    function getMinLimit(
        address addr)
        external
        view
        validStorageAddress
        returns (uint8 limit)
    {
        uint8 limit = IANSStorage(_storageAddress).getMinLimit(addr);
        if (limit > 0) {
            return limit;
        }
        return NAME_MIN_LIMIT;
    }
}
