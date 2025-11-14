class Player {
  final String id;
  final String name;
  final bool isHost;

  Player({
    required this.id,
    required this.name,
    this.isHost = false,
  });

  factory Player.fromMap(Map<dynamic, dynamic> map) {
    return Player(
      id: map['id'] as String,
      name: map['name'] as String,
      isHost: map['isHost'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'isHost': isHost,
  };

  Player copyWith({
    String? id,
    String? name,
    bool? isHost,
  }) => Player(
    id: id ?? this.id,
    name: name ?? this.name,
    isHost: isHost ?? this.isHost,
  );
}
