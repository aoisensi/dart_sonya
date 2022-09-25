part of 'discord.dart';

User _storeUser(Reader read, Map<String, dynamic> json, UserId currentUserId) {
  final user = User.fromJson(json);
  read(DiscordCache.users(CacheKey(currentUserId, user.id)).state).state = user;
  return user;
}

User _storeCurrentUser(Reader read, Map<String, dynamic> json) =>
    _storeUser(read, json, UserId(json['id']));
