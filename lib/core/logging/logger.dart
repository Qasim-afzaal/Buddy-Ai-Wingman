import 'package:logger/logger.dart';

/// Custom logger implementation for the application
/// Provides contextual logging with class names for better debugging
class CustomLogger extends LogPrinter {
  final String className;

  CustomLogger({required this.className});

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter().levelColors![event.level]!;
    final emoji = PrettyPrinter().levelEmojis![event.level];
    return [color('$emoji $className - ${event.message}')];
  }
}

/// Creates a logger instance with custom formatting
/// 
/// [className] - The name of the class using the logger for better context
/// Returns a configured Logger instance
Logger getLogger(String className) =>
    Logger(printer: CustomLogger(className: className));
