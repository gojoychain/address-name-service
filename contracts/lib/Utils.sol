pragma solidity ^0.5.4;

library Utils {
    function validateNotHex(bytes memory b) internal pure returns (bool) {
        // Check length before trying to access at index
        if (b.length >= 2) {
            return b[0] != 0x30 && b[1] != 0x78;
        }
        return true;
    }

    function validateLettersAndNumbers(bytes memory b) internal pure returns (bool) {
        for (uint i = 0; i < b.length; i++) {
            bytes1 char = b[i];

            // See ASCII table for reference: http://www.asciitable.com/
            // If not 0-9,A-Z, or a-z, return not valid.
            if (
                !(char >= 0x30 && char <= 0x39) && // 0-9
                !(char >= 0x41 && char <= 0x5A) && // A-Z
                !(char >= 0x61 && char <= 0x7A)    // a-z
            ) {
                return false;
            }
        }
        return true;
    }
    
    function toLower(bytes memory b) internal pure returns (bytes memory) {
        bytes memory lowerBytes = new bytes(b.length);
        for (uint i = 0; i < b.length; i++) {
            lowerBytes[i] = toLower(b[i]);
        }
        return lowerBytes;
    }

    function toLower(bytes1 b) internal pure returns (bytes1) {
        if (b >= 0x41 && b <= 0x5A) {
            return bytes1(uint8(b) + 32);
        }
        return b;
    }

    function toBytes(string memory s) internal pure returns (bytes memory) {
        return bytes(s);
    }

    function toString(bytes memory b) internal pure returns (string memory) {
        return string(b);
    }
}
