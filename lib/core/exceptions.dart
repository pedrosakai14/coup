class CommonException implements Exception {
  final String message;

  CommonException(this.message);

  @override
  String toString() => message;
}

class RoomIsFullException extends CommonException {
  RoomIsFullException() : super('A sala já está cheia.');
}

class RoomNotFoundException extends CommonException {
  RoomNotFoundException() : super('A sala não foi encontrada.');
}

class RoomAlreadyExistsException extends CommonException {
  RoomAlreadyExistsException() : super('A sala com este código já existe.');
}

class JoinRoomFailedException extends CommonException {
  JoinRoomFailedException(super.message);
}
