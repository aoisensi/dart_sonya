import 'package:riverpod/riverpod.dart';

import 'cache.dart';
import 'entity/id.dart';
import 'entity/user.dart';

class DiscordProvider {
  DiscordProvider._();

  static final currentUserId =
      Provider<UserId>((ref) => throw UnimplementedError());

  static final user = Provider.family<User?, UserId>(
    (ref, id) =>
        ref.watch(DiscordCache.users(CacheKey(ref.watch(currentUserId), id))),
    dependencies: [currentUserId],
  );
}
