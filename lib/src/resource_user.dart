part of 'discord.dart';

class _DiscordResourceUser extends _DiscordResource {
  _DiscordResourceUser(super.discord);

  Future<User> getUser(UserId id) => _getUser(id.toString());
  Future<User> getCurrentUser() => _getUser('@me');

  Future<User> _getUser(String ident) async {
    final self = ident == '@me';
    final json = await _get('/users/$ident');
    return self
        ? _storeCurrentUser(_read, json)
        : _storeUser(_read, json, _currentUserId);
  }
}
