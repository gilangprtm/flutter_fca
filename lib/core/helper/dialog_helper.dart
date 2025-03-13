import 'package:flutter/material.dart';

import '../../main.dart';
import '../mahas/mahas_type.dart';
import '../mahas/widget/mahas_alert.dart';

final context = navigatorKey.currentContext;

class DialogHelper {
  static void showErrorDialog(String message) {
    showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.error,
          content: Text(message),
        );
      },
    );
  }

  static void showInfoDialog(String message) {
    showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.info,
          content: Text(message),
        );
      },
    );
  }

  static void showSuccessDialog({String message = ''}) {
    showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.succes,
          content: Text(message),
        );
      },
    );
  }

  static Future<bool> showConfirmationDialog({
    String message = '',
    Function? onPositivePressed,
    Function? onNegativePressed,
  }) async {
    return await showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.confirmation,
          content: Text(message),
          onPositivePressed: () {
            Navigator.of(context).pop(true);
            onPositivePressed;
            return true;
          },
          onNegativePressed: () {
            Navigator.of(context).pop(false);
            onNegativePressed;
            return false;
          },
        );
      },
    );
  }

  static Future dialogFullScreen(Widget child) async {
    await showDialog(
      context: context!,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
