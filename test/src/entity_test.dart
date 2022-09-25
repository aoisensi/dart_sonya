import 'dart:convert';

import 'package:sonya/sonya.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('fromJson', () {
      final actual = User.fromJson(
        jsonDecode('''
{
  "id": "80351110224678912",
  "username": "Nelly",
  "discriminator": "1337",
  "avatar": "8342729096ea3675442027381ff50dfe",
  "verified": true,
  "email": "nelly@discord.com",
  "flags": 64,
  "banner": "06c16474723fe537c283b8efa61a30c8",
  "accent_color": 16711680,
  "premium_type": 1,
  "public_flags": 64
}
'''),
      );
      final matcher = User(
        id: actual.id,
        username: 'Nelly',
        discriminator: '1337',
        avatar: '8342729096ea3675442027381ff50dfe',
      );
      expect(actual, matcher);
    });
  });
}
