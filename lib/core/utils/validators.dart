import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:whatsapp/core/utils/app_strings.dart';

class Validators {
  static String? validateNormalText(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.fieldIsRequired);
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final RegExp regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.emailIsRequired);
    } else if (!regex.hasMatch(value)) {
      return context.tr(AppStrings.invalidEmail);
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.passwordIsRequired);
    } else if (value.length < 8) {
      return context.tr(AppStrings.passwordTooShort);
    }
    return null;
  }

  static String? confirmPasswordValidator(
      BuildContext context, String? value, String? password) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.confirmPasswordIsRequired);
    } else if (password == null || password.isEmpty) {
      return context.tr(AppStrings.passwordIsRequired);
    } else if (value != password) {
      return context.tr(AppStrings.passwordsDoNotMatch);
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    const String phonePattern = r'^\+?[0-9]{11}$';
    final RegExp regex = RegExp(phonePattern);
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.phoneIsRequired);
    } else if (!regex.hasMatch(value)) {
      return context.tr(AppStrings.invalidPhone);
    }
    return null;
  }

  static String? validateAge(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.tr(AppStrings.ageIsRequired);
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return context.tr(AppStrings.invalidAge);
    }
    if (age < 14) {
      return context.tr(AppStrings.ageTooYoung);
    }
    if (age > 150) {
      return context.tr(AppStrings.ageTooOld);
    }
    return null;
  }
}
