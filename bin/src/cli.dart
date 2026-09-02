import 'dart:io';
import 'build_manager.dart';

/// Command-line interface handler for Tezkor build commands.
///
/// This class processes command-line arguments and delegates build operations
/// to the [BuildManager].
class CLI {
  /// Runs the CLI with the provided [arguments].
  ///
  /// Expects arguments in the format: `build <target> [--<environment>] [flags]`
  /// where target can be `apk`, `ipa`, `appbundle`, `win`, or `mac`.
  /// Environment is optional - if not provided, runs plain Flutter build command.
  ///
  /// Throws an [Exception] if the command format is invalid.
  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty ||
        arguments.contains('--help') ||
        arguments.contains('-h') ||
        arguments.contains('help')) {
      _printHelp();
      return;
    }

    if (arguments.contains('update')) {
      await _updateCLI();
      return;
    }

    if (arguments[0] != 'build') {
      print('❌ Noto\'g\'ri buyruq. Yordam uchun: tezkor help');
      return;
    }

    final target = arguments[1];
    final env = parseEnv(arguments);

    // Extract extra flags, excluding environment flags
    final List<String> extraFlags = arguments.length > 2
        ? arguments
            .sublist(2)
            .where((arg) =>
                arg != '--production' &&
                arg != '-p' &&
                arg != '-prod' &&
                arg != '--staging' &&
                arg != '-s' &&
                arg != '--development' &&
                arg != '-d' &&
                arg != '-dev')
            .toList()
        : [];

    await BuildManager().execute(target, env, extraFlags);
  }

  /// Parses the environment from command-line arguments.
  ///
  /// Recognizes production flags: `--production`, `-p`, `-prod`
  /// Recognizes staging flags: `--staging`, `-s`
  /// Recognizes development flags: `--development`, `-d`, `-dev`
  ///
  /// Returns the environment name or null if not specified.
  static String? parseEnv(List<String> args) {
    if (args.contains('--production') ||
        args.contains('-p') ||
        args.contains('-prod')) {
      return 'production';
    }
    if (args.contains('--staging') || args.contains('-s')) {
      return 'staging';
    }
    if (args.contains('--development') ||
        args.contains('-d') ||
        args.contains('-dev')) {
      return 'development';
    }
    return null; // No environment specified - use plain Flutter command
  }

  Future<void> _updateCLI() async {
    print('🔄 Tezkor yangilanmoqda...');
    try {
      final result =
          await Process.run('dart', ['pub', 'global', 'activate', 'tezkor']);
      if (result.exitCode == 0) {
        print('✅ Tezkor muvaffaqiyatli yangilandi!');
        print(result.stdout);
      } else {
        print('❌ Yangilashda xatolik: ${result.stderr}');
      }
    } catch (e) {
      print('❌ Xatolik: $e');
    }
  }

  void _printHelp() {
    print('''
🌟 Tezkor CLI - Flutter loyihalarini boshqarish uchun yordamchi

Foydalanish:
  tezkor build <target> [environment] [options]
  tezkor update

Buyruqlar:
  build             Dasturni qurish (apk, ipa, appbundle, win, mac)
  update            CLI ni eng so'nggi versiyaga yangilash
  help              Yordam oynasini ko'rsatish

Targetlar (builddan keyin):
  apk               Android APK fayl yaratish
  ipa               iOS IPA fayl yaratish
  appbundle         Android App Bundle (.aab) yaratish
  win               Windows uchun desktop build (.exe) yaratish
  mac               macOS uchun desktop build (.app) yaratish

Environmentlar (ixtiyoriy):
  --production, -p  Production uchun build
  --staging, -s     Staging uchun build
  --development, -d Development uchun build

Qo'shimcha:
  --split           APK ni har bir arxitektura uchun alohida bo'lish

Misollar:
  tezkor build apk --production
  tezkor update
''');
  }
}
