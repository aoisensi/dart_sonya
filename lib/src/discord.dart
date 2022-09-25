import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import 'cache.dart';
import 'entity/id.dart';
import 'entity/user.dart';
import 'provider.dart';
import 'token.dart';

part 'store.dart';
part 'resource_user.dart';

class Discord {
  Discord._(this._read, this._token, this._currentUser);

  User get currentUser => _currentUser!;
  final User? _currentUser;
  DiscordToken _token;
  final Reader _read;

  final _http = http.Client();

  late final user = _DiscordResourceUser(this);

  static Future<Discord> login(Reader read, DiscordToken token) async {
    if (token.type == DiscordTokenType.client) throw UnimplementedError();
    final fake = Discord._(read, token, null);
    final userId = await fake.user.getCurrentUser();
    return Discord._(read, fake._token, userId);
  }

  Future<void> exchangeRefreshToken() async {
    final url = Uri.https('discord.com', '/api/oauth2/token');
    final resp = await _http.post(
      url,
      body: {
        'client_id': _token.clientId,
        'client_secret': _token.clientSecret,
        'grant_type': 'refresh_token',
        'refresh_token': _token.refreshToken,
      },
    );
    if (resp.statusCode != 200) throw Exception();
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final expiredDate =
        DateTime.now().add(Duration(seconds: json['expires_in']));
    _updateToken(
      DiscordToken.bearer(
        clientId: _token.clientId!,
        clientSecret: _token.clientSecret!,
        accessToken: json['access_token'],
        expiredDate: expiredDate,
        refreshToken: json['refresh_token'],
      ),
    );
  }

  void _updateToken(DiscordToken token) {
    _token = token;
    if (_currentUser != null) {
      _read(DiscordCache.tokens(currentUser.id).state).state = token;
    }
  }

  Override get override =>
      DiscordProvider.currentUserId.overrideWithValue(currentUser.id);

  String get _authorization {
    switch (_token.type) {
      case DiscordTokenType.bot:
        return 'Bot ${_token.accessToken}';
      case DiscordTokenType.bearer:
        return 'Bearer ${_token.accessToken}';
      case DiscordTokenType.client:
        throw UnimplementedError();
    }
  }
}

abstract class _DiscordResource {
  const _DiscordResource(this._discord);
  final Discord _discord;

  Future<dynamic> _get(String path) async {
    await _ifNeededRefresh();
    final resp = await _discord._http.get(_url(path), headers: _header);
    return _parse(resp);
  }

  Map<String, String> get _header => {'Authorization': _discord._authorization};

  dynamic _parse(http.Response resp) {
    final code = resp.statusCode;
    if (200 > code || code >= 300) {
      throw Exception(resp);
    }
    return jsonDecode(utf8.decode(resp.bodyBytes));
  }

  Future<void> _ifNeededRefresh() async {
    if (!_discord._token.needsRefresh()) return;
    await _discord.exchangeRefreshToken();
  }

  Uri _url(String path) => Uri.https('discord.com', '/api/v10$path');

  UserId get _currentUserId => _discord.currentUser.id;
  Reader get _read => _discord._read;
}
