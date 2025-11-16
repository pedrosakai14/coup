import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

enum LobbyAlerts {
  playerRemovedSuccess,
  playerRemovedFails,
  roomCrowded,
  genericError,
  youWereKicked;

  (String, Color) get alertSnack {
    return switch (this) {
      LobbyAlerts.playerRemovedSuccess => (
        'Jogador removido com sucesso',
        CommonColors.secondaryColor,
      ),
      LobbyAlerts.playerRemovedFails => (
        'Ocorreu um problema ao remover o jogador',
        CommonColors.errorColor,
      ),
      LobbyAlerts.roomCrowded => (
        'A sala em questão já está lotada :(',
        CommonColors.errorColor,
      ),
      LobbyAlerts.genericError => (
        'Ocorreu algum erro, tente novamente',
        CommonColors.errorColor,
      ),
      LobbyAlerts.youWereKicked => (
        'Você foi expulso da sala',
        CommonColors.errorColor,
      ),
    };
  }

  bool get shouldPop {
    return switch (this) {
      LobbyAlerts.playerRemovedSuccess || LobbyAlerts.playerRemovedFails => false,
      LobbyAlerts.roomCrowded || LobbyAlerts.genericError || LobbyAlerts.youWereKicked => true,
    };
  }
}
