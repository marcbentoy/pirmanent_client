import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MarkedLog {
  MarkedLog();

  final String logFileName = 'app.log';

  Future<String> get logFileDir async {
    final directory = await getApplicationDocumentsDirectory();
    final Directory fullLogFileDir =
        Directory(p.join(directory.path, 'pirmanent'));

    if (!(await fullLogFileDir.exists())) {
      fullLogFileDir.create(recursive: true);
    }

    return fullLogFileDir.path;
  }

  String getPrefix(int level) {
    switch (level) {
      case 1:
        return "[DEBUG]";
      case 2:
        return "[ERROR]";
      default:
        return "[INFO]";
    }
  }

  void log(int level, String message) {
    final String content = "${getPrefix(level)} ${DateTime.now()} $message";
    // log message to console if in debug mode
    if (kDebugMode) {
      print(content);
    }
    // log message to log file
    logToFile(content);
  }

  void logToFile(String content) async {
    final filePath = p.join(await logFileDir, logFileName);
    final file = File(filePath);
    file.writeAsString('$content\n', mode: FileMode.append);
  }

  void info(String message) {
    log(0, message);
  }

  void debug(String message) {
    log(1, message);
  }

  void error(String message) {
    log(2, message);
  }
}
