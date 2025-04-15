import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = AppColors.primary,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style:
          AppTextStyles.poppinsBold(context, 20).copyWith(color: Colors.white),
    ),
    showCloseIcon: true,
    duration: const Duration(seconds: AppConstants.snackBarDuration),
    backgroundColor: backgroundColor,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
