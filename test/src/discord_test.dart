import 'package:dotenv/dotenv.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sonya/sonya.dart';
import 'package:test/test.dart';

void main() {
  late DotEnv env;
  late Discord discord;
  // ignore: unused_local_variable
  late ProviderContainer container;
  setUp(() async {
    env = DotEnv(includePlatformEnvironment: true)..load(['test.env']);
    final parent = ProviderContainer();
    final token = DiscordToken.bot(env['BOT_TOKEN']!);
    discord = await Discord.login(parent.read, token);
    container = ProviderContainer(
      parent: parent,
      overrides: [discord.override],
    );
  });
  group('Discord', () {
    group('user', () {
      test('getCurrentUser', () async {
        final user = discord.currentUser;
        expect(user.username, 'aoisensi');
      });
      test('getUser', () async {
        final user =
            await discord.user.getUser(const UserId('135617831864762368'));
        expect(user.username, 'aoisensi');
      });
    });
  });
}
