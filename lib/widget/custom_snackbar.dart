import 'package:flutter/material.dart';

enum SnackBartype { positive, nagetive }

class CustomSnackBar {
  CustomSnackBar(
      BuildContext objBuildContext, String message, SnackBartype type) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor:
          type == SnackBartype.positive ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
    );
    Scaffold.of(objBuildContext).hideCurrentSnackBar();
    Scaffold.of(objBuildContext).showSnackBar(snackBar);
  }

  // void showSnackBar(BuildContext objBuildContext, String message) {}
}
