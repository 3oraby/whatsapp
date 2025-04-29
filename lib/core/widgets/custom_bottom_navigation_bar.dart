import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onTabChange,
    required this.currentViewIndex,
  });

  final ValueChanged<int> onTabChange;
  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavTheme = theme.bottomNavigationBarTheme;
    final selectedIconTheme = bottomNavTheme.selectedIconTheme ??
        const IconThemeData(color: AppColors.actionColor, size: 26);
    final unselectedIconTheme = bottomNavTheme.unselectedIconTheme ??
        const IconThemeData(color: Colors.grey, size: 24);

    final items = AppConstants.bottomNavigationBarItems(context: context);

    return BottomNavigationBar(
      currentIndex: currentViewIndex,
      onTap: onTabChange,
      type: BottomNavigationBarType.fixed,
      items: List.generate(items.length, (index) {
        final isSelected = currentViewIndex == index;
        final iconSize =
            isSelected ? selectedIconTheme.size! : unselectedIconTheme.size!;
        final iconColor =
            isSelected ? selectedIconTheme.color! : unselectedIconTheme.color!;

        return BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: SvgPicture.asset(
              items[index].iconName,
              key: ValueKey<bool>(isSelected),
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: items[index].name,
        );
      }),
    );
  }
}
