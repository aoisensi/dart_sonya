import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

import 'entity/id.dart';
import 'entity/user.dart';
import 'token.dart';

class DiscordCache {
  DiscordCache._();

  static final tokens =
      StateProvider.family<DiscordToken?, UserId>((ref, arg) => null);
  static final users =
      StateProvider.family<User?, CacheKey<UserId>>((ref, arg) => null);
}

@immutable
class CacheKey<T> {
  const CacheKey(this.accountId, this.pointer);

  final UserId accountId;
  final T pointer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CacheKey) return false;
    return runtimeType == other.runtimeType &&
        accountId == other.accountId &&
        pointer == other.pointer;
  }

  @override
  int get hashCode => Object.hash(runtimeType, accountId, pointer);
}
