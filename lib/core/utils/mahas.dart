import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Mahas {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext? context() {
    return _context;
  }

  static Map<String, String> _parameters = {};

  static void setParameters(Map<String, String> params) {
    _parameters = params;
  }

  static Map<String, String> parameters() {
    return _parameters;
  }

  static Future<void> routeTo(String routeName,
      {Map<String, String>? params}) async {
    if (_context != null) {
      if (params != null) {
        setParameters(params);
      }
      await Navigator.pushNamed(_context!, routeName);
    }
  }

  static void snackbar(String title, String message) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('$title: $message'),
        ),
      );
    }
  }

  static Future<void> dialog(Widget dialog) async {
    if (_context != null) {
      showDialog(
        context: _context!,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }

  /// Mendapatkan dependensi dari service locator
  static T find<T extends Object>() {
    return GetIt.instance<T>();
  }

  static Locale? locale() {
    // Implement localization logic here
    return null;
  }

  static ThemeData? theme() {
    // Implement theme management logic here
    return null;
  }
}
