import 'dart:async';
import 'dart:math' hide log;

import 'package:coup/src/coup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class RoomRepositoryImpl implements RoomRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Future<(Room, String)> createRoom(String userName) async {
    final playerId = Uuid().v4();
    final roomCode = _randomRoomCode;
    final roomRef = _database.ref('rooms/$roomCode');

    final hostPlayer = Player(
      id: playerId,
      name: userName,
      isHost: true,
    );

    final roomData = Room(
      code: roomCode,
      hostId: hostPlayer.id,
      status: RoomStatus.waiting,
      players: [hostPlayer],
    );

    final TransactionResult result = await roomRef.runTransaction((Object? data) {
      if (data != null) throw RoomAlreadyExistsException();

      return Transaction.success(roomData.toMap());
    });

    if (!result.committed) throw RoomAlreadyExistsException();

    return (roomData, playerId);
  }

  @override
  Future<(Room, String)> joinRoom(String userName, String roomCode) async {
    final playerId = Uuid().v4();
    final roomRef = _database.ref('rooms/$roomCode');

    final TransactionResult result = await roomRef.runTransaction((Object? data) {
      if (data == null) return Transaction.success(data);

      final currentRoom = Room.fromMap(data as Map<dynamic, dynamic>);
      if (currentRoom.players.length == CommonConstants.MAX_PLAYERS) throw RoomIsFullException();

      String finalUserName = userName;
      final allNames = currentRoom.players.map((e) => e.name).toSet();
      if (allNames.contains(finalUserName)) {
        int i = 2;
        while (true) {
          final newName = '$userName ($i)';
          if (!allNames.contains(newName)) {
            finalUserName = newName;
            break;
          }
          i++;
          if (i > CommonConstants.MAX_PLAYERS) {
            throw JoinRoomFailedException('invalid username');
          }
        }
      }

      final newPlayer = Player(id: playerId, name: finalUserName);

      final newPlayersList = currentRoom.players.toList()..add(newPlayer);
      final newRoomData = currentRoom.copyWith(players: newPlayersList);

      return Transaction.success(newRoomData.toMap());
    });

    if (!result.committed || result.snapshot.value == null) {
      throw JoinRoomFailedException('error when joining room');
    }

    final finalRoomData = Room.fromMap(result.snapshot.value as Map<dynamic, dynamic>);
    return (finalRoomData, playerId);
  }

  @override
  Stream<Room> getRoomStream(String roomCode) {
    final roomRef = _database.ref('rooms/$roomCode');

    return roomRef.onValue.map((event) {
      if (event.snapshot.value == null) throw RoomNotFoundException();

      final roomDataMap = event.snapshot.value as Map<dynamic, dynamic>;
      return Room.fromMap(roomDataMap);
    });
  }

  @override
  Future<void> updateRoom(String roomCode, Room newRoomData) async {
    final roomRef = _database.ref('rooms/$roomCode');
    await roomRef.set(newRoomData.toMap());
  }

  @override
  Future<void> updatePlayers(String roomCode, List<Player> newPlayersList) async {
    final roomRef = _database.ref('rooms/$roomCode');
    final playersMap = {
      for (var p in newPlayersList) p.id: p.toMap(),
    };

    await roomRef.child('players').set(playersMap);
  }

  @override
  Future<void> deleteRoom(String roomCode) async {
    final roomRef = _database.ref('rooms/$roomCode');
    await roomRef.remove();
  }

  String get _randomRoomCode {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        5,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
