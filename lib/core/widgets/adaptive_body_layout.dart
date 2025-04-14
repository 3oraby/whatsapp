import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/size_config.dart';

class AdaptiveBodyLayout extends StatelessWidget {
  const AdaptiveBodyLayout({
    super.key,
    required this.mobilePageLayout,
    required this.tabletPageLayout,
    required this.desktopPageLayout,
  });

  final WidgetBuilder mobilePageLayout, tabletPageLayout, desktopPageLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < SizeConfig.tabletBreakPoint) {
          return mobilePageLayout(context);
        } else if (constraints.maxWidth < SizeConfig.desktopBreakPoint) {
          return tabletPageLayout(context);
        } else {
          return desktopPageLayout(context);
        }
      },
    );
  }
}