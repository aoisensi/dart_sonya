enum DiscordTokenType { bearer, bot, client }

class DiscordToken {
  DiscordToken._({
    this.clientId,
    this.clientSecret,
    this.accessToken,
    this.refreshToken,
    this.expiredDate,
    required this.type,
  });

  final String? clientId;
  final String? clientSecret;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiredDate;
  final DiscordTokenType type;

  factory DiscordToken.bot(String token) => DiscordToken._(
        accessToken: token,
        type: DiscordTokenType.bot,
      );

  factory DiscordToken.bearer({
    required String clientId,
    required String clientSecret,
    String? accessToken,
    required String refreshToken,
    DateTime? expiredDate,
  }) =>
      DiscordToken._(
        clientId: clientId,
        clientSecret: clientSecret,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiredDate: expiredDate ?? DateTime(0),
        type: DiscordTokenType.bearer,
      );

  factory DiscordToken.client({
    required String clientId,
    required String clientSecret,
  }) =>
      DiscordToken._(
        clientId: clientId,
        clientSecret: clientSecret,
        type: DiscordTokenType.client,
      );

  bool needsRefresh() {
    switch (type) {
      case DiscordTokenType.bot:
        return false;
      case DiscordTokenType.bearer:
        if (accessToken == null) return true;
        if (expiredDate == null) return false;
        return expiredDate!.difference(DateTime.now()).inSeconds < 10;

      case DiscordTokenType.client:
        throw UnimplementedError('Cannot refresh client only token.');
    }
  }
}
