pragma solidity ^0.5.4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/storage/ANSStorage.sol";
import "../../contracts/ans/ANS.sol";

contract TestANS {
    address storageAddr;
    // ANS ans;

    function beforeEach() public {
        storageAddr = DeployedAddresses.ANSStorage();
        // ans = ANS(DeployedAddresses.ANS());
    }

    // function testAssignName(accounts) public {
    //     bytes32 name = "abcdefghijk";
    //     ANS.assignName(storageAddr, name);
    //     address resolved = ANS.resolveName(storageAddr, name);
    //     Assert.equal(resolved, msg.sender, "Resolved address does not match.");
    // }
}
