import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class UserProfileScreen extends StatelessWidget {
  final UserEntity user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  void _copyEmail(BuildContext context, String email) {
    Clipboard.setData(ClipboardData(text: email));
    showCustomSnackBar(
      context,
      "Email copied to clipboard",
      backgroundColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: AppTextStyles.poppinsBold(context, 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VerticalGap(24),
          BuildUserProfileImage(
            circleAvatarRadius: 60,
            userEntity: user,
            profilePicUrl: user.profileImage,
          ),
          const VerticalGap(16),
          Text(
            user.name,
            style: AppTextStyles.poppinsBold(context, 22),
          ),
          const VerticalGap(8),
          Text(
            user.phoneNumber ?? "Number",
            style: AppTextStyles.poppinsMedium(context, 16).copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const VerticalGap(24),

          GestureDetector(
            onTap: () => _copyEmail(context, user.email),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      user.email,
                      style: AppTextStyles.poppinsMedium(context, 16).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.copy,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          const VerticalGap(24),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            subtitle: Text(
              "Hey there! I am using WhatsApp.",
            ),
          ),
        ],
      ),
    );
  }
}
