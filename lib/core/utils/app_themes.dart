import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'app_colors.dart';

class AppThemes {
  static ThemeData getLightTheme(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.appBackgroundLight,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.actionColor,
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: AppTextStyles.poppinsRegular(context, 16)
              .copyWith(color: AppColors.textPrimaryLight),
          bodyMedium: AppTextStyles.poppinsRegular(context, 16)
              .copyWith(color: AppColors.textSecondaryLight),
        ),
        dividerColor: AppColors.dividerLight,
        iconTheme: const IconThemeData(color: AppColors.iconLight),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightInputBackground,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightInputBackground),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: AppColors.lightInputBackground,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: AppColors.primary,
            ), // Focused border color
          ),
        ),
      );

  static ThemeData getDarkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.appBackgroundDark,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.actionColor,
          foregroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          bodyLarge: AppTextStyles.poppinsRegular(context, 16)
              .copyWith(color: AppColors.textPrimaryDark),
          bodyMedium: AppTextStyles.poppinsRegular(context, 16)
              .copyWith(color: AppColors.textSecondaryDark),
        ),
        dividerColor: AppColors.dividerDark,
        iconTheme: const IconThemeData(color: AppColors.iconDark),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkInputBackground,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkInputBackground),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: AppColors.primary,
            ), // Focused border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: AppColors.darkInputBackground,
            ),
          ),
        ),
      );
}
