import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'app_colors.dart';

class AppThemes {
  static ThemeData getLightTheme(BuildContext context) => ThemeData(
        primaryColor: AppColors.primaryLight,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          secondary: AppColors.textSecondaryLight,
        ),
        scaffoldBackgroundColor: AppColors.appBackgroundLight,
        appBarTheme: AppBarTheme(
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
        iconTheme: const IconThemeData(
          color: AppColors.iconLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.poppinsMedium(context, 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        ),
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
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primaryLight,
          circularTrackColor: AppColors.lightInputBackground,
          strokeWidth: 4.0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.appBackgroundLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryLight,
          selectedLabelStyle: AppTextStyles.poppinsMedium(context, 12),
          unselectedLabelStyle: AppTextStyles.poppinsRegular(context, 12),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );

  static ThemeData getDarkTheme(BuildContext context) => ThemeData(
        primaryColor: AppColors.primaryDark,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          secondary: AppColors.textSecondaryDark,
        ),
        scaffoldBackgroundColor: AppColors.appBackgroundDark,
        appBarTheme: AppBarTheme(
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
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.poppinsMedium(context, 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        ),
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
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primaryDark,
          circularTrackColor: AppColors.darkInputBackground,
          strokeWidth: 4.0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.appBackgroundDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryDark,
          selectedLabelStyle: AppTextStyles.poppinsMedium(context, 12),
          unselectedLabelStyle: AppTextStyles.poppinsRegular(context, 12),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );
}
