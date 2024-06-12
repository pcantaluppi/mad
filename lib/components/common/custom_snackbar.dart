import 'package:flutter/material.dart';

class CustomSnackbar {
  static double? snackBarHeight = 50.0;

  static void showLoading(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.down,
        backgroundColor: Theme.of(context).primaryColorLight,
        content: SizedBox(
          height: snackBarHeight,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, String message,
      [int? durationSeconds]) {
    durationSeconds = durationSeconds ?? 2;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.down,
        duration: Duration(seconds: durationSeconds),
        backgroundColor:
            Theme.of(context).primaryColorLight,
        content: SizedBox(
          height: snackBarHeight,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
