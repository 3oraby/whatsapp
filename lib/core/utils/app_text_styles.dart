import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle _textStyle(
      BuildContext context, double size, FontWeight weight) {
    return TextStyle(
      fontFamily: 'UberMove',
      fontSize: size,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      fontWeight: weight,
    );
  }

  static TextStyle uberMoveRegular(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w400);
  static TextStyle uberMoveMedium(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w500);
  static TextStyle uberMoveSemiBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w600);
  static TextStyle uberMoveBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w700);
  static TextStyle uberMoveExtraBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w800);
  static TextStyle uberMoveBlack(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w900);
}