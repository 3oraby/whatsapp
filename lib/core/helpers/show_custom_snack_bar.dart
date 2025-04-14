import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = AppColors.primaryColor,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
    backgroundColor: backgroundColor,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
