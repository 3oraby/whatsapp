import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_svgs.dart';
import 'package:whatsapp/features/home/domain/entities/bottom_navigation_bar_item_entity.dart';

class AppConstants {
  static const double borderRadius = 12;
  static const double bottomSheetBorderRadius = 28;
  static const double horizontalPadding = 12;
  static const double horizontalDrawerPadding = 24;
  static const double topPadding = 16;
  static const double bottomPadding = 36;
  static const double contentTextFieldPadding = 22;
  static const int snackBarDuration = 3;
  static const int splashScreenDuration = 3;

  static List<BottomNavigationBarItemEntity> bottomNavigationBarItems(
          {required BuildContext context}) =>
      [
        BottomNavigationBarItemEntity(
          iconName: AppSvgs.svgsStatusIcon,
          name: context.tr("Status"),
        ),
        BottomNavigationBarItemEntity(
          iconName: AppSvgs.svgsChatsIcon, 
          name: context.tr("Chats"),
        ),
        BottomNavigationBarItemEntity(
          iconName: AppSvgs.svgsCameraIcon,
          name: context.tr("Camera"),
        ),
        BottomNavigationBarItemEntity(
          iconName: AppSvgs.svgsContactsIcon,
          name: context.tr("Contacts"),
        ),
        BottomNavigationBarItemEntity(
          iconName: AppSvgs.svgsSettingsIcon,
          name: context.tr("Settings"),
        ),
      ];
}
