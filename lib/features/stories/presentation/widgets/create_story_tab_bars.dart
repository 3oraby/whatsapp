import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class CreateStoryTabBars extends StatelessWidget {
  const CreateStoryTabBars({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      unselectedLabelColor: Colors.white70,
      unselectedLabelStyle: AppTextStyles.poppinsMedium(context, 20),
      labelStyle: AppTextStyles.poppinsMedium(context, 22).copyWith(
        color: AppColors.primary,
      ),
      tabs: const [
        Tab(text: "PHOTO"),
        Tab(text: "TEXT"),
      ],
    );
  }
}
