/// File system utilities for the CLI.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

/// File system utilities.
class FileUtils {
  FileUtils._();

  /// Create directory if it doesn't exist.
  static Future<Directory> ensureDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Create directory synchronously.
  static Directory ensureDirectorySync(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Write file with content.
  static Future<File> writeFile(String path, String content) async {
    final file = File(path);
    await ensureDirectory(p.dirname(path));
    return file.writeAsString(content);
  }

  /// Write file synchronously.
  static File writeFileSync(String path, String content) {
    final file = File(path);
    ensureDirectorySync(p.dirname(path));
    file.writeAsStringSync(content);
    return file;
  }

  /// Read file content.
  static Future<String> readFile(String path) async {
    return File(path).readAsString();
  }

  /// Check if file exists.
  static Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  /// Check if directory exists.
  static Future<bool> directoryExists(String path) async {
    return Directory(path).exists();
  }

  /// Copy file.
  static Future<File> copyFile(String source, String destination) async {
    await ensureDirectory(p.dirname(destination));
    return File(source).copy(destination);
  }

  /// Copy directory recursively.
  static Future<void> copyDirectory(String source, String destination) async {
    final sourceDir = Directory(source);
    await ensureDirectory(destination);

    await for (final entity in sourceDir.list(recursive: false)) {
      final newPath = p.join(destination, p.basename(entity.path));

      if (entity is File) {
        await entity.copy(newPath);
      } else if (entity is Directory) {
        await copyDirectory(entity.path, newPath);
      }
    }
  }

  /// Delete file or directory.
  static Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      return;
    }

    final dir = Directory(path);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// List files in directory.
  static Future<List<FileSystemEntity>> listDirectory(
    String path, {
    bool recursive = false,
    bool filesOnly = false,
    bool directoriesOnly = false,
  }) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      return [];
    }

    final entities = <FileSystemEntity>[];
    await for (final entity in dir.list(recursive: recursive)) {
      if (filesOnly && entity is! File) continue;
      if (directoriesOnly && entity is! Directory) continue;
      entities.add(entity);
    }
    return entities;
  }

  /// Get file extension.
  static String getExtension(String path) {
    return p.extension(path);
  }

  /// Get file name without extension.
  static String getBaseName(String path) {
    return p.basenameWithoutExtension(path);
  }

  /// Get file name with extension.
  static String getFileName(String path) {
    return p.basename(path);
  }

  /// Join paths.
  static String join(String part1, [String? part2, String? part3, String? part4]) {
    return p.join(part1, part2, part3, part4);
  }

  /// Normalize path.
  static String normalize(String path) {
    return p.normalize(path);
  }

  /// Get absolute path.
  static String absolute(String path) {
    return p.absolute(path);
  }

  /// Get relative path.
  static String relative(String path, {String? from}) {
    return p.relative(path, from: from);
  }

  /// Check if path is absolute.
  static bool isAbsolute(String path) {
    return p.isAbsolute(path);
  }

  /// Get current working directory.
  static String get currentDirectory => Directory.current.path;

  /// Get home directory.
  static String? get homeDirectory {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    return home;
  }

  /// Make path valid for file names.
  static String sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Convert to snake_case for file names.
  static String toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .toLowerCase();
  }
}

