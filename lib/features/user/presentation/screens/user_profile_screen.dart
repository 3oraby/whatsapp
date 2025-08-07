import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/services/image_picker_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/auth/presentation/cubits/set_user_profile_picture_cubit/set_user_profile_picture_cubit.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class UserProfileScreen extends StatefulWidget {
  final UserEntity user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserEntity? currentUser;
  final ImagePickerService _imagePickerService = ImagePickerService();
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  void _copyEmail(BuildContext context, String email) {
    Clipboard.setData(ClipboardData(text: email));
    showCustomSnackBar(
      context,
      "Email copied to clipboard",
      backgroundColor: Colors.black,
    );
  }

  void _showEditPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _imagePickerService.pickImageFromCamera();
                  if (pickedFile != null) {
                    setState(() {
                      _localImagePath = pickedFile.path;
                    });
                    BlocProvider.of<SetUserProfilePictureCubit>(context)
                        .uploadUserProfileImg(
                      mediaFile: pickedFile,
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);

                  Navigator.pushNamed(
                    context,
                    Routes.setUserProfileImgRoute,
                    arguments: false,
                  );
                },
              ),
              Visibility(
                visible: widget.user.profileImage != null,
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text(
                    'Delete Photo',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    BlocProvider.of<SetUserProfilePictureCubit>(context)
                        .deleteUserProfileImg();
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = _localImagePath ?? widget.user.profileImage;

    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackgroundColor,
        title: Text(
          widget.user.name,
          style: AppTextStyles.poppinsBold(context, 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const VerticalGap(24),
            Hero(
              tag: "userProfileImg",
              child: GestureDetector(
                onTap: () {
                  if (imageUrl != null) {
                    Navigator.pushNamed(
                      context,
                      Routes.fullUserProfileImgRoute,
                      arguments: {
                        "imagePath": imageUrl,
                        "heroTag": "userProfileImg",
                      },
                    );
                  }
                },
                child: BuildUserProfileImage(
                  circleAvatarRadius: 100,
                  userEntity: widget.user,
                  isEnabled: false,
                  isCurrentUser: currentUser?.id == widget.user.id,
                ),
              ),
            ),
            TextButton(
              onPressed: _showEditPhotoOptions,
              child: Text(
                "Edit Photo",
                style: AppTextStyles.poppinsBold(context, 18).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const VerticalGap(16),
            Text(
              widget.user.name,
              style: AppTextStyles.poppinsBold(context, 22),
            ),
            const VerticalGap(8),
            Text(
              widget.user.phoneNumber ?? "Number",
              style: AppTextStyles.poppinsMedium(context, 16).copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const VerticalGap(24),
            if (widget.user.email != null)
              GestureDetector(
                onTap: () => _copyEmail(context, widget.user.email!),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                          widget.user.email!,
                          style:
                              AppTextStyles.poppinsMedium(context, 16).copyWith(
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
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                tileColor: Colors.white,
                leading: const Icon(Icons.info_outline),
                title: Text(
                  "About",
                  style: AppTextStyles.poppinsMedium(context, 16),
                ),
                subtitle: Text(
                  widget.user.description ?? "Hey there! I am using WhatsApp.",
                  style: AppTextStyles.poppinsMedium(context, 16).copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
