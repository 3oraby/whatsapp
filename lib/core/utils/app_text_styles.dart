import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle _textStyle(
      BuildContext context, double size, FontWeight weight) {
    return TextStyle(
      fontFamily: 'SpecialGothicCondensedOne',
      fontSize: size,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      fontWeight: weight,
    );
  }

  static TextStyle specialGothicCondensedOneRegular(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w400);
  static TextStyle specialGothicCondensedOneMedium(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w500);
  static TextStyle specialGothicCondensedOneSemiBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w600);
  static TextStyle specialGothicCondensedOneBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w700);
  static TextStyle specialGothicCondensedOneExtraBold(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w800);
  static TextStyle specialGothicCondensedOneBlack(BuildContext context, double size) =>
      _textStyle(context, size, FontWeight.w900);
}
