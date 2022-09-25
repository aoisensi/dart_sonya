import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract class BaseId {
  const BaseId(String id) : _id = id;
  final String _id;

  @override
  String toString() => _id;

  @override
  bool operator ==(Object other) =>
      other is BaseId && _id == other._id && runtimeType == other.runtimeType;

  @override
  int get hashCode => Object.hash(runtimeType, _id);

  String toJson() => '"$_id"';
}

@immutable
class UserId extends BaseId {
  const UserId(super.id);
  factory UserId.fromJson(String id) => UserId(id);
}

@immutable
class GuildId extends BaseId {
  const GuildId(super.id);
  factory GuildId.fromJson(String id) => GuildId(id);
}

@immutable
class ChannelId extends BaseId {
  const ChannelId(super.id);
  factory ChannelId.fromJson(String id) => ChannelId(id);
}
