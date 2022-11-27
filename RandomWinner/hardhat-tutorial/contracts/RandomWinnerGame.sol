// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomWinnerGame is VRFConsumerBase, Ownable {


    bytes32 public keyHash;
    uint256 public fee;
    bool gameStarted;
    uint8 maxPlayers;
    uint256 entryFee;
    uint256 public gameId;
    address[] public players;

    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 entryFee);
    event PlayerJoined(uint256 gameId, address player);
    event GameEnded(uint256 gameId, address winner, bytes32 reqeestID);



    constructor(
        address vrfCoordinator,
        address linkToken,
        bytes32 vrfKeyHash,
        uint256 vrfFee
    ) VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = vrfKeyHash;
        fee = vrfFee;
        gameStarted = false;
    }


    function startGame(uint8 _maxPlayers, uint256 _entryFee) public onlyOwner {
        require(!gameStarted, "Game has already started");

        delete players;
        maxPlayers = _maxPlayers;
        entryFee = _entryFee;
        gameStarted = true;
        gameId += 1;

        emit GameStarted(gameId, _maxPlayers, _entryFee);
    }



    function joinGame() public payable {
        require(gameStarted, "Game hasnt started yet");
        require(players.length < maxPlayers, "Game is alredy full");
        require(msg.value >= entryFee, "Value sent is less than entry fee");

        players.push(msg.sender);
        emit PlayerJoined(gameId, msg.sender);

        if (players.length == maxPlayers) {
            getRandomWinner();
        }
    }

    /* 
check if our contract has enough links to request for randomness function from chainlink
call requestRandomness(kehHash,fee)
 */

    function getRandomWinner() private returns (bytes32 requestID) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Contract doesnt have enough link token to call chainlink randomness function"
        );
        return requestRandomness(keyHash, fee);
    }

    /* 
internal : func can be called from within contract or from inheriting contract
virtual: it means this func can be overridden by inhereting contract
override: fun was overridden from another base contract 
 */

    /* 
 This func is called br VRFCoordinator wehn it receives requestRandomness() with valid VRF froof
 We override this functon to use randomness generated according to our need(i.e random <=max no of playes)
 reqeestID is unique for each call to the function set by VRFcoordinator 
 randomness is randomuint256 generated and returned by VRf coordinator
  */
    function fulfillRandomness(bytes32 requestID, uint256 randomness)
        internal
        virtual
        override
    {
        uint256 winnerIndex = randomness % players.length;
        address winner = players[winnerIndex];

        (bool sent, ) = winner.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");

        emit GameEnded(gameId, winner, requestID);
        gameStarted = false;
    }

    receive() external payable {}

    fallback() external payable {}
}
