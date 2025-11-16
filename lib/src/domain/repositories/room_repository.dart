import 'package:coup/src/coup.dart';

abstract class RoomRepository {
  Future<(Room, String)> createRoom(String userName);

  Future<(Room, String)> joinRoom(String userName, String roomCode);

  Stream<Room> getRoomStream(String roomCode);

  Future<void> updateRoom(String roomCode, Room newRoomData);

  Future<void> updatePlayers(String roomCode, List<Player> newPlayersList);

  Future<void> deleteRoom(String roomCode);
}