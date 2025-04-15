import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';

class AppTextStyles {
  static TextStyle _textStyle(
      BuildContext context, double size, FontWeight weight) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.textPrimaryDark
          : AppColors.textPrimaryLight,
      fontWeight: weight,
    );
  }

  static TextStyle poppinsThin(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w100);
  static TextStyle poppinsLight(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w300);
  static TextStyle poppinsRegular(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w400);
  static TextStyle poppinsMedium(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w500);
  static TextStyle poppinsSemiBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w600);
  static TextStyle poppinsBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w700);
  static TextStyle poppinsExtraBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w800);
  static TextStyle poppinsBlack(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w900);
}
