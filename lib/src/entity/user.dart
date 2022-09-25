import 'package:freezed_annotation/freezed_annotation.dart';

import '../constant.dart';
import 'id.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required UserId id,
    required String username,
    required String discriminator,
    required String? avatar,
  }) = _User;
  const User._();

  String getAvatarUrl() => avatar != null
      ? '$baseUrlCdn/avatars/$id/$avatar.webp'
      : '$baseUrlCdn/embed/avatars/${int.parse(discriminator) % 5}.png';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
