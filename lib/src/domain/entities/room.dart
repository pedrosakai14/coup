import 'package:coup/src/coup.dart';

enum RoomStatus { waiting, inProgress }

class Room {
  final String code;
  final String hostId;
  final RoomStatus status;
  final List<Player> players;

  Room({
    required this.code,
    required this.hostId,
    required this.status,
    required this.players,
  });

  factory Room.fromMap(Map<dynamic, dynamic> map) {
    final playersMap = map['players'] as Map<dynamic, dynamic>? ?? {};
    final playersList = playersMap.values.map((playerData) {
      return Player.fromMap(playerData as Map<dynamic, dynamic>);
    }).toList();

    final statusString = map['status'] as String? ?? 'waiting';
    final status = RoomStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => RoomStatus.waiting,
    );

    return Room(
      code: map['code'] as String,
      hostId: map['hostId'] as String,
      status: status,
      players: playersList,
    );
  }

  Map<String, dynamic> toMap() => {
    'code': code,
    'hostId': hostId,
    'status': status.name,
    'players': {
      for (var player in players) player.id: player.toMap(),
    },
  };

  Room copyWith({
    String? code,
    String? hostId,
    RoomStatus? status,
    List<Player>? players,
  }) => Room(
    code: code ?? this.code,
    hostId: hostId ?? this.hostId,
    status: status ?? this.status,
    players: players ?? this.players,
  );
}
