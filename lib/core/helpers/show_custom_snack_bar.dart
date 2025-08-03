import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.black,
  bool showCloseIcon = true,
  int durationDay = 0,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style:
          AppTextStyles.poppinsBold(context, 20).copyWith(color: Colors.white),
    ),
    showCloseIcon: showCloseIcon,
    duration: Duration(
      seconds: AppConstants.snackBarDuration,
      days: durationDay,
    ),
    backgroundColor: backgroundColor,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
