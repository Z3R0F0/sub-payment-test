import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  static void showShortToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      textColor: Colors.white,
      fontSize: 12,
    );
  }

  static void showLongToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static void showAlert(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Additional functions for future use:

  static void showSuccessNotification(BuildContext context, String message) {
    // Implement success notification logic here
  }

  static void showErrorNotification(BuildContext context, String errorMessage) {
    // Implement error notification logic here
  }
}
