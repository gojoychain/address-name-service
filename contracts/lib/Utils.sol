pragma solidity ^0.5.4;

library Utils {
    function validateNotHex(bytes memory b) internal pure returns (bool) {
        return b[0] != 0x30 && b[1] != 0x78;
    }

    function validateLettersAndNumbers(bytes memory b) internal pure returns (bool) {
        for (uint i = 0; i < b.length; i++) {
            // See ASCII table for reference: http://www.asciitable.com/
            if (
                b[i] < 0x30 ||                  // b < 0
                (b[i] > 0x39 && b[i] < 0x41) || // b > 9 && b < A
                (b[i] > 0x5a && b[i] < 0x61) || // b > Z && b < a
                b[i] > 0x7a                     // b > z
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
