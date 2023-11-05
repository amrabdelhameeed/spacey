import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar._();
  static void show(
      {required BuildContext context,
      required String text,
      Widget button = const SizedBox.shrink(),
      Color backgroundColor = Colors.black87,
      Color textColor = Colors.white,
      DismissDirection dismissDirection = DismissDirection.horizontal,
      Duration duration = const Duration(seconds: 4),
      ShapeBorder? shape,
      EdgeInsets margin = const EdgeInsets.symmetric(vertical: 30, horizontal: 20)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      animation: const AlwaysStoppedAnimation<double>(2.0),
      duration: duration,
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      dismissDirection: dismissDirection,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: margin,
      content: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
          button
        ],
      ),
    ));
  }
}
