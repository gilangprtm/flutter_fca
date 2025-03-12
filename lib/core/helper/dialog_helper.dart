import 'package:flutter/material.dart';

import '../mahas/mahas_type.dart';
import '../mahas/widget/mahas_alert.dart';

class DialogHelper {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.error,
          content: Text(message),
        );
      },
    );
  }

  static void showInfoDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.info,
          content: Text(message),
        );
      },
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.succes,
          content: Text(message),
        );
      },
    );
  }

  static void showConfirmationDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.confirmation,
          content: Text(message),
        );
      },
    );
  }
}
