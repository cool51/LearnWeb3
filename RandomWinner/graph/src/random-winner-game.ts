import { BigInt } from "@graphprotocol/graph-ts";
import {
  PlayerJoined,
  GameEnded,
  GameStarted,
  OwnershipTransferred,
} from "../generated/RandomWinnerGame/RandomWinnerGame";
import { Game } from "../generated/schema";

export function handleGameEnded(event: GameEnded): void {
  let entity = Game.load(event.params.gameId.toString());

  if (!entity) {
    return;
  }

  entity.winner = event.params.winner;
  entity.reqeestId = event.params.reqeestID;

  entity.save();
}

export function handleGameStarted(event: GameStarted): void {
  let entity = Game.load(event.params.gameId.toString());

  if (!entity) {
    entity = new Game(event.params.gameId.toString());
    entity.players = [];
  }
  entity.maxPlayers = event.params.maxPlayers;
  entity.entryFee = event.params.entryFee;
  entity.save();
}

export function handlePlayerJoined(event: PlayerJoined): void {
  let entity = Game.load(event.params.gameId.toString());
  if (!entity) {
    return;
  }
  let newPlayers = entity.players;
  newPlayers.push(event.params.player);
  entity.players = newPlayers;
  entity.save();
}

export function handleOwnershipTransferred(event: OwnershipTransferred): void {}

// export function handleGameEnded(event: GameEndedEvent): void {
//   let entity = new GameEnded(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   );
//   entity.gameId = event.params.gameId;
//   entity.winner = event.params.winner;
//   entity.reqeestID = event.params.reqeestID;

//   entity.blockNumber = event.block.number;
//   entity.blockTimestamp = event.block.timestamp;
//   entity.transactionHash = event.transaction.hash;

//   entity.save();
// }

// export function handleGameStarted(event: GameStartedEvent): void {
//   let entity = new GameStarted(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   );
//   entity.gameId = event.params.gameId;
//   entity.maxPlayers = event.params.maxPlayers;
//   entity.entryFee = event.params.entryFee;

//   entity.blockNumber = event.block.number;
//   entity.blockTimestamp = event.block.timestamp;
//   entity.transactionHash = event.transaction.hash;

//   entity.save();
// }

// export function handleOwnershipTransferred(
//   event: OwnershipTransferredEvent
// ): void {
//   let entity = new OwnershipTransferred(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   );
//   entity.previousOwner = event.params.previousOwner;
//   entity.newOwner = event.params.newOwner;

//   entity.blockNumber = event.block.number;
//   entity.blockTimestamp = event.block.timestamp;
//   entity.transactionHash = event.transaction.hash;

//   entity.save();
// }

// export function handlePlayerJoined(event: PlayerJoinedEvent): void {
//   let entity = new PlayerJoined(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   );
//   entity.gameId = event.params.gameId;
//   entity.player = event.params.player;

//   entity.blockNumber = event.block.number;
//   entity.blockTimestamp = event.block.timestamp;
//   entity.transactionHash = event.transaction.hash;

//   entity.save();
// }
