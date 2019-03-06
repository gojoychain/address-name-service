pragma solidity ^0.5.4;

library Utils {
    function toLower(bytes memory b) internal pure returns (bytes memory) {
        bytes memory lowerBytes = new bytes(32);
        for (uint i = 0; i < 32; i++) {
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
}
