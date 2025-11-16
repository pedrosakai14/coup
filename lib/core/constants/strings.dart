class Strings {
  const Strings._();

  // commons
  static String get createRoom => 'Criar sala';

  static String get joinRoom => 'Entrar em sala';

  static String get btnContinue => 'Continuar';

  static String get loading => 'Carregando...';

  static String get you => 'Você';

  static String get host => 'Host';

  static String get username => 'nome de usuário';

  static String get roomCode => 'Código da Sala';

  static String get genericError => 'Ocorreu algum erro, tente novamente';

  // create_room_modal
  static String get createRoomModalSubtitle => 'Digite seu nome para criar uma nova sala';

  // join_room_modal
  static String get joinRoomModalSubtitle => 'Digite seu nome para entrar em uma nova sala';

  // lobby_alerts
  static String get lobbyAlertsPlayerRemovedSuccess => 'Jogador removido com sucesso';

  static String get lobbyAlertsPlayerRemovedFails => 'Ocorreu um problema ao remover o jogador';

  static String get lobbyAlertsRoomCrowded => 'A sala em questão já está lotada :(';

  static String get lobbyAlertsYouWereKicked => 'Você foi expulso da sala';

  // code_card
  static String get codeCardCopyCodeSuccess => 'Código copiado com sucesso';

  static String get codeCardCopyCodeBtn => 'Copiar código';

  // lobby_page
  static String get lobbyPageAppbarTitle => 'Sala de espera';

  static String get lobbyPageBtnTextHost => 'Começar jogo';

  static String get lobbyPageBtnTextNonHost => 'Aguardando host começar';

  // lobby_loaded_view
  static String get lobbyLoadedViewAlert => 'Precisa de\n2 a 6 jogadores';

  static String lobbyLoadedViewPlayersNumber(int qtd) => 'Jogadores ($qtd/6)';
}
