import 'dart:math';

enum LogType {
  start,
  info,
  step,
  success,
  error,
  finished,
  buildConfigIsNotExist,
  running,
  donation,
  buildNumberIncremented,
  fileSaved,
  outputDirCreated
}

class Logger {
  static final _random = Random();
  static String _currentLanguage = 'uz';

  static void setLanguage(String language) {
    if (['uz', 'en', 'ru'].contains(language)) {
      _currentLanguage = language;
    } else {
      // Unsupported language - fallback to English with warning
      _currentLanguage = 'en';
      print(
          '\x1B[33m⚠️  Warning: Language "$language" is not supported. Falling back to English.\x1B[0m');
      print(
          '\x1B[33m   Supported languages: uz (Uzbek), en (English), ru (Russian)\x1B[0m\n');
    }
  }

  /// Returns localized progress task message
  static String getProgressTask(String taskKey) {
    final tasks = _progressTasks[_currentLanguage];
    return tasks?[taskKey] ?? taskKey;
  }

  /// Progress task translations
  static final Map<String, Map<String, String>> _progressTasks = {
    'uz': {
      'starting': 'Boshlanyapti...',
      'gradle': 'Gradle ishlayapti...',
      'dependencies_downloading': 'Dependencylar yuklanmoqda...',
      'dependencies_ready': 'Dependencylar tayyor...',
      'compiling': 'Flutter kodi kompilyatsiya qilinyapti...',
      'bundling': 'Bundle yaratilmoqda...',
      'assembling': 'APK/AAB yig\'ilmoqda...',
      'signing': 'Imzolanmoqda...',
      'finishing': 'Tugallanmoqda...',
      'ready': 'Tayyor!',
    },
    'en': {
      'starting': 'Starting...',
      'gradle': 'Running Gradle...',
      'dependencies_downloading': 'Downloading dependencies...',
      'dependencies_ready': 'Dependencies ready...',
      'compiling': 'Compiling Flutter code...',
      'bundling': 'Creating bundle...',
      'assembling': 'Assembling APK/AAB...',
      'signing': 'Signing...',
      'finishing': 'Finishing...',
      'ready': 'Ready!',
    },
    'ru': {
      'starting': 'Начинается...',
      'gradle': 'Запуск Gradle...',
      'dependencies_downloading': 'Загрузка зависимостей...',
      'dependencies_ready': 'Зависимости готовы...',
      'compiling': 'Компиляция кода Flutter...',
      'bundling': 'Создание bundle...',
      'assembling': 'Сборка APK/AAB...',
      'signing': 'Подписывается...',
      'finishing': 'Завершается...',
      'ready': 'Готово!',
    },
  };

  static final Map<String, Map<LogType, List<String>>> _translations = {
    'uz': {
      LogType.start: [
        '🚀 Boshlash: Build {target} ({env} mode),',
        '✨ Tayyor tur: {target} build ishga tushdi ({env}),',
        '🏁 Jarayon boshlandi: {target} ({env}),'
      ],
      LogType.step: [
        '🔧 {target} build bosqichi: Flutter komandalar bajarilmoqda, Xo\'jayiin...',
        '⚙️ Jarayon: Build bosqichlari ishlamoqda, Xo\'jayiin...',
        '🛠️ Step: {target} build jarayoni davom etmoqda, Xo\'jayiin...'
      ],
      LogType.success: [
        '✅ {target} build muvaffaqiyatli yakunlandi,',
        '🎉 Ilova tayyor: {target} ({env}),',
        '🏆 {target} build muvaffaqiyatli tugadi,'
      ],
      LogType.error: [
        '❌ {target} build xatolik yuz berdi,',
        '💥 Nimadir noto\'g\'ri ketdi: {target} ({env}),',
        '⚠️ Build bajarilmadi: {target} ({env}),'
      ],
      LogType.buildConfigIsNotExist: [
        '⚠️ Build config topilmadi, default yaratilmoqda,',
        '📝 build_config.json yo\'q, default config yaratdim,',
        'ℹ️ Konfiguratsiya yaratilmoqda,'
      ],
      LogType.running: [
        '🔄 Ishga tushirilmoqda: {command},',
        '⏳ Komanda bajarilmoqda: {command},',
        '🏃 Jarayon: {command},'
      ],
      LogType.buildNumberIncremented: [
        '✅ Build number yangilandi: {oldBuild} → {newBuild},',
        '🔢 Build raqami ko\'tarildi: {oldBuild} → {newBuild},',
        '📈 Yangi build number: {newBuild} (oldingi: {oldBuild}),'
      ],
      LogType.fileSaved: [
        '✅ Build saqlandi: {path},',
        '💾 Fayl tayyor: {path},',
        '📦 Build muvaffaqiyatli ko\'chirildi: {path},'
      ],
      LogType.outputDirCreated: [
        '📁 Output directory yaratildi: {path},',
        '🗂️ Yangi papka tuzildi: {path},',
        '✨ Output papka tayyor: {path},'
      ],
    },
    'en': {
      LogType.start: [
        '🚀 Starting: Build {target} ({env} mode), Boss!',
        '✨ Ready: {target} build started ({env}), Boss!',
        '🏁 Process started: {target} ({env}), Boss!'
      ],
      LogType.step: [
        '🔧 {target} build step: Running Flutter commands, Boss...',
        '⚙️ Process: Build steps in progress, Boss...',
        '🛠️ Step: {target} build process ongoing, Boss...'
      ],
      LogType.success: [
        '✅ {target} build completed successfully, Boss!',
        '🎉 App ready: {target} ({env}), Boss!',
        '🏆 {target} build finished successfully, Boss!'
      ],
      LogType.error: [
        '❌ {target} build failed, Boss!',
        '💥 Something went wrong: {target} ({env}), Boss!',
        '⚠️ Build failed: {target} ({env}), Boss!'
      ],
      LogType.buildConfigIsNotExist: [
        '⚠️ Build config not found, creating default, Boss!',
        '📝 build_config.json missing, created default config, Boss!',
        'ℹ️ Creating configuration, Boss!'
      ],
      LogType.running: [
        '🔄 Running: {command}, Boss!',
        '⏳ Executing command: {command}, Boss!',
        '🏃 Process: {command}, Boss!'
      ],
      LogType.buildNumberIncremented: [
        '✅ Build number updated: {oldBuild} → {newBuild}, Boss!',
        '🔢 Build number incremented: {oldBuild} → {newBuild}, Boss!',
        '📈 New build number: {newBuild} (previous: {oldBuild}), Boss!'
      ],
      LogType.fileSaved: [
        '✅ Build saved: {path}, Boss!',
        '💾 File ready: {path}, Boss!',
        '📦 Build successfully moved: {path}, Boss!'
      ],
      LogType.outputDirCreated: [
        '📁 Output directory created: {path}, Boss!',
        '🗂️ New folder created: {path}, Boss!',
        '✨ Output folder ready: {path}, Boss!'
      ],
    },
    'ru': {
      LogType.start: [
        '🚀 Начало: Сборка {target} (режим {env}), Босс!',
        '✨ Готово: запущена сборка {target} ({env}), Босс!',
        '🏁 Процесс начат: {target} ({env}), Босс!'
      ],
      LogType.step: [
        '🔧 Шаг сборки {target}: выполняются команды Flutter, Босс...',
        '⚙️ Процесс: идут этапы сборки, Босс...',
        '🛠️ Шаг: процесс сборки {target} продолжается, Босс...'
      ],
      LogType.success: [
        '✅ Сборка {target} успешно завершена, Босс!',
        '🎉 Приложение готово: {target} ({env}), Босс!',
        '🏆 Сборка {target} успешно завершена, Босс!'
      ],
      LogType.error: [
        '❌ Ошибка сборки {target}, Босс!',
        '💥 Что-то пошло не так: {target} ({env}), Босс!',
        '⚠️ Сборка не удалась: {target} ({env}), Босс!'
      ],
      LogType.buildConfigIsNotExist: [
        '⚠️ Конфиг сборки не найден, создаю стандартный, Босс!',
        '📝 build_config.json отсутствует, создал стандартный конфиг, Босс!',
        'ℹ️ Создаю конфигурацию, Босс!'
      ],
      LogType.running: [
        '🔄 Запуск: {command}, Босс!',
        '⏳ Выполняется команда: {command}, Босс!',
        '🏃 Процесс: {command}, Босс!'
      ],
      LogType.buildNumberIncremented: [
        '✅ Build number обновлён: {oldBuild} → {newBuild}, Босс!',
        '🔢 Build number увеличен: {oldBuild} → {newBuild}, Босс!',
        '📈 Новый build number: {newBuild} (предыдущий: {oldBuild}), Босс!'
      ],
      LogType.fileSaved: [
        '✅ Сборка сохранена: {path}, Босс!',
        '💾 Файл готов: {path}, Босс!',
        '📦 Сборка успешно перемещена: {path}, Босс!'
      ],
      LogType.outputDirCreated: [
        '📁 Выходная папка создана: {path}, Босс!',
        '🗂️ Новая папка создана: {path}, Босс!',
        '✨ Выходная папка готова: {path}, Босс!'
      ],
    },
  };

  static String _color(String text, String colorCode) =>
      '\x1B[${colorCode}m$text\x1B[0m';

  static void log(LogType type,
      {String target = '',
      String env = '',
      String file = '',
      String command = '',
      String oldBuild = '',
      String newBuild = '',
      String path = ''}) {
    final messages = _translations[_currentLanguage];
    if (messages == null) return;

    final list = messages[type];
    if (list == null || list.isEmpty) return;

    // Random selection
    final message = list[_random.nextInt(list.length)]
        .replaceAll('{target}', target)
        .replaceAll('{env}', env)
        .replaceAll('{file}', file)
        .replaceAll('{command}', command)
        .replaceAll('{oldBuild}', oldBuild)
        .replaceAll('{newBuild}', newBuild)
        .replaceAll('{path}', path);

    String coloredMessage;
    switch (type) {
      case LogType.start:
        coloredMessage = _color(message, '34'); // Blue
        break;
      case LogType.step:
        coloredMessage = _color(message, '36'); // Cyan
        break;
      case LogType.success:
      case LogType.buildNumberIncremented:
      case LogType.fileSaved:
      case LogType.outputDirCreated:
        coloredMessage = _color(message, '32'); // Green
        break;
      case LogType.error:
        coloredMessage = _color(message, '31'); // Red
        break;
      case LogType.donation:
        coloredMessage = _color(message, '35'); // Magenta
        break;
      case LogType.info:
      case LogType.finished:
      case LogType.buildConfigIsNotExist:
      case LogType.running:
        coloredMessage = _color(message, '33'); // Yellow
        break;
    }

    print(coloredMessage);
  }
}
