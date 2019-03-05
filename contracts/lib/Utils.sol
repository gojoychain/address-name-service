pragma solidity ^0.5.4;

contract Utils {
    function toLower(bytes1 b) private pure returns (bytes1) {
        if (b >= 0x41 && b <= 0x5A) {
            return bytes1(uint8(b) + 32);
        }
        return b;
    }
}
