/// Console utilities for CLI output.
library;

import 'dart:io';

/// ANSI color codes.
class AnsiColors {
  AnsiColors._();

  static const String reset = '\x1B[0m';
  static const String bold = '\x1B[1m';
  static const String dim = '\x1B[2m';
  static const String italic = '\x1B[3m';
  static const String underline = '\x1B[4m';

  // Colors
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';

  // Bright colors
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
}

/// Console output helper.
class Console {
  Console._();

  static bool _useColors = stdout.supportsAnsiEscapes;

  /// Enable or disable colors.
  static void setColorsEnabled(bool enabled) {
    _useColors = enabled && stdout.supportsAnsiEscapes;
  }

  /// Print with color.
  static void write(String message, {String? color}) {
    if (_useColors && color != null) {
      stdout.write('$color$message${AnsiColors.reset}');
    } else {
      stdout.write(message);
    }
  }

  /// Print line with color.
  static void writeLine(String message, {String? color}) {
    write('$message\n', color: color);
  }

  /// Print blank line.
  static void blank() => stdout.writeln();

  // ===== Semantic Outputs =====

  /// Print success message.
  static void success(String message) {
    writeLine('✓ $message', color: AnsiColors.green);
  }

  /// Print error message.
  static void error(String message) {
    writeLine('✗ $message', color: AnsiColors.red);
  }

  /// Print warning message.
  static void warning(String message) {
    writeLine('⚠ $message', color: AnsiColors.yellow);
  }

  /// Print info message.
  static void info(String message) {
    writeLine('ℹ $message', color: AnsiColors.blue);
  }

  /// Print hint message.
  static void hint(String message) {
    writeLine('  $message', color: AnsiColors.dim);
  }

  /// Print step message.
  static void step(String message) {
    writeLine('→ $message', color: AnsiColors.cyan);
  }

  /// Print header.
  static void header(String message) {
    blank();
    writeLine(message, color: '${AnsiColors.bold}${AnsiColors.white}');
    writeLine('─' * message.length, color: AnsiColors.dim);
  }

  /// Print subheader.
  static void subheader(String message) {
    blank();
    writeLine(message, color: AnsiColors.bold);
  }

  /// Print key-value pair.
  static void keyValue(String key, String value) {
    write('  $key: ', color: AnsiColors.dim);
    writeLine(value);
  }

  /// Print list item.
  static void listItem(String item, {int indent = 0}) {
    final prefix = '  ' * indent;
    writeLine('$prefix• $item');
  }

  /// Print numbered item.
  static void numberedItem(int number, String item) {
    write('  $number. ', color: AnsiColors.cyan);
    writeLine(item);
  }

  /// Print divider.
  static void divider({int width = 60}) {
    writeLine('─' * width, color: AnsiColors.dim);
  }

  /// Print box around text.
  static void box(String message, {String? title}) {
    final lines = message.split('\n');
    final maxLength = lines.fold<int>(
      title?.length ?? 0,
      (max, line) => line.length > max ? line.length : max,
    );
    final width = maxLength + 4;

    writeLine('╭${'─' * (width - 2)}╮', color: AnsiColors.dim);
    if (title != null) {
      final padding = width - title.length - 4;
      writeLine('│ ${AnsiColors.bold}$title${AnsiColors.reset}${' ' * padding} │',
          color: AnsiColors.dim);
      writeLine('├${'─' * (width - 2)}┤', color: AnsiColors.dim);
    }
    for (final line in lines) {
      final padding = width - line.length - 4;
      writeLine('│ $line${' ' * padding} │', color: AnsiColors.dim);
    }
    writeLine('╰${'─' * (width - 2)}╯', color: AnsiColors.dim);
  }

  // ===== Kiro Branding =====

  /// Print Kiro banner.
  static void banner() {
    const kiroArt = '''
    
  ██╗  ██╗██╗██████╗  ██████╗ 
  ██║ ██╔╝██║██╔══██╗██╔═══██╗
  █████╔╝ ██║██████╔╝██║   ██║
  ██╔═██╗ ██║██╔══██╗██║   ██║
  ██║  ██╗██║██║  ██║╚██████╔╝
  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝ 
''';
    writeLine(kiroArt, color: AnsiColors.brightCyan);
    writeLine('  Modular App Generator v0.1.0', color: AnsiColors.dim);
    blank();
  }

  /// Print completion message.
  static void complete(String projectName) {
    blank();
    success('Project "$projectName" created successfully!');
    blank();
    info('Next steps:');
    numberedItem(1, 'cd $projectName');
    numberedItem(2, 'flutter pub get');
    numberedItem(3, 'flutter run');
    blank();
    writeLine('Happy coding! 🚀', color: AnsiColors.brightMagenta);
    blank();
  }
}

/// Progress indicator.
class Progress {
  final String _message;
  bool _complete = false;
  int _frame = 0;
  final List<String> _frames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

  Progress(this._message);

  /// Start the progress indicator.
  void start() {
    stdout.write('${AnsiColors.cyan}${_frames[0]}${AnsiColors.reset} $_message');
  }

  /// Update the spinner.
  void tick() {
    if (_complete) return;
    _frame = (_frame + 1) % _frames.length;
    stdout.write('\r${AnsiColors.cyan}${_frames[_frame]}${AnsiColors.reset} $_message');
  }

  /// Complete with success.
  void success([String? message]) {
    _complete = true;
    stdout.write('\r${AnsiColors.green}✓${AnsiColors.reset} ${message ?? _message}\n');
  }

  /// Complete with failure.
  void fail([String? message]) {
    _complete = true;
    stdout.write('\r${AnsiColors.red}✗${AnsiColors.reset} ${message ?? _message}\n');
  }
}

