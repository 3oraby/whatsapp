import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onTabChange,
  });

  final ValueChanged onTabChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      child: CustomAppPadding(
        vertical: 8,
        child: GNav(
          gap: 4,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          activeColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: 16,
          ),
          onTabChange: onTabChange,
          tabs: AppConstants.bottomNavigationBarItems(context: context).map(
            (item) {
              return GButton(
                icon: item.itemIcon,
                text: item.name,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
