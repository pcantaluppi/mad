//logger.dart
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if an error is thrown
      lineLength: 120, // width of the log print
      colors: true, // Colorful log messages
      printEmojis: true, // Print emojis for each log message
      printTime: true // Should each log contain a timestamp
      ),
);
