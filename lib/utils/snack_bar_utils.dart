import 'package:flutter/material.dart';

/// A mixin that provides snack bar functionality to any widget state class
mixin SnackBarMixin<T extends StatefulWidget> on State<T> {
  static String OK = 'OK';

  /// Shows a snack bar message using a SnackBar
  void showSnackBar(String message) {
    // Only proceed if the widget is still mounted
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: OK,
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
