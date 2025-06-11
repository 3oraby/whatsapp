import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';

class ShowCurrentUserStoryViews extends StatelessWidget {
  const ShowCurrentUserStoryViews({
    super.key,
    required this.views,
    required this.onBottomSheetOpened,
    required this.onBottomSheetClosed,
  });

  final List<ViewStoryEntity> views;
  final VoidCallback onBottomSheetOpened;
  final VoidCallback onBottomSheetClosed;

  void _showViewersBottomSheet(BuildContext context) {
    onBottomSheetOpened();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return CustomAppPadding(
          child: Column(
            children: [
              const VerticalGap(16),
              Container(
                height: 6,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const VerticalGap(8),
              Row(
                children: [
                  Text(
                    "${views.length} views",
                    style: AppTextStyles.poppinsMedium(context, 18),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: views.length,
                  separatorBuilder: (context, index) => const VerticalGap(4),
                  itemBuilder: (context, index) {
                    final view = views[index];
                    return Row(
                      children: [
                        BuildUserProfileImage(
                          circleAvatarRadius: 22,
                          profilePicUrl: view.user.profileImage,
                        ),
                        const HorizontalGap(12),
                        Expanded(
                          child: Column(
                            children: [
                              const VerticalGap(12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    view.user.name,
                                    style: AppTextStyles.poppinsMedium(
                                        context, 18),
                                  ),
                                  Text(
                                    TimeAgoService.formatForStoryViewers(
                                        view.createdAt),
                                    style: AppTextStyles.poppinsMedium(
                                        context, 14),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      onBottomSheetClosed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showViewersBottomSheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.expand_less, size: 32, color: Colors.white),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye, size: 22, color: Colors.white),
              const HorizontalGap(4),
              Text(
                views.length.toString(),
                style: AppTextStyles.poppinsBold(context, 14).copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
