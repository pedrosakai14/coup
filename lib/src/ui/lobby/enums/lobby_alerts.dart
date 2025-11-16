import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

enum LobbyAlerts {
  playerRemovedSuccess,
  playerRemovedFails,
  roomCrowded,
  genericError,
  youWereKicked,
  codeCopiedSuccess;

  (String, Color) get alertSnack {
    return switch (this) {
      LobbyAlerts.playerRemovedSuccess => (Strings.lobbyAlertsPlayerRemovedSuccess, CommonColors.secondaryColor),
      LobbyAlerts.playerRemovedFails => (Strings.lobbyAlertsPlayerRemovedFails, CommonColors.errorColor),
      LobbyAlerts.roomCrowded => (Strings.lobbyAlertsRoomCrowded, CommonColors.errorColor),
      LobbyAlerts.genericError => (Strings.genericError, CommonColors.errorColor),
      LobbyAlerts.youWereKicked => (Strings.lobbyAlertsYouWereKicked, CommonColors.errorColor),
      LobbyAlerts.codeCopiedSuccess => (Strings.codeCardCopyCodeSuccess, CommonColors.secondaryColor),
    };
  }

  bool get shouldPop {
    return switch (this) {
      LobbyAlerts.playerRemovedSuccess || LobbyAlerts.playerRemovedFails || LobbyAlerts.codeCopiedSuccess => false,
      LobbyAlerts.roomCrowded || LobbyAlerts.genericError || LobbyAlerts.youWereKicked => true,
    };
  }
}
