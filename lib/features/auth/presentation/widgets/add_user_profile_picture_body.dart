import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';
import 'package:whatsapp/core/widgets/custom_trigger_button.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/auth/presentation/cubits/set_user_profile_picture_cubit/set_user_profile_picture_cubit.dart';

class SetUserProfilePictureBody extends StatefulWidget {
  const SetUserProfilePictureBody({super.key});

  @override
  State<SetUserProfilePictureBody> createState() =>
      _SetUserProfilePictureBodyState();
}

class _SetUserProfilePictureBodyState extends State<SetUserProfilePictureBody> {
  bool _isImageUploaded = false;
  bool _isPickedImageLoading = false;
  File? fileImage;

  void _onSaveAndProceedButtonPressed() {
    if (_isImageUploaded) {
      BlocProvider.of<SetUserProfilePictureCubit>(context).uploadUserProfileImg(
        mediaFile: fileImage!,
      );
    } else {
      showCustomSnackBar(
        context,
        context.tr("Please upload a profile picture before proceeding."),
      );
    }
  }

  Future<void> _onAddImagePressed() async {
    try {
      setState(() {
        _isPickedImageLoading = true;
      });
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        fileImage = File(image.path);
        setState(() {
          _isImageUploaded = true;
        });
      }
    } catch (e) {
      log("There is an exception with adding an image in AddUserProfileScreen: $e");
      throw CustomException(message: "Failed to upload image".tr());
    } finally {
      setState(() {
        _isPickedImageLoading = false;
      });
    }
  }

  void _onSkipForNowButtonPressed() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.homeRoute,
      (route) => false,
    );
  }

  void _onRemoveImagePressed() {
    setState(() {
      fileImage = null;
      _isImageUploaded = false;
    });
    showCustomSnackBar(
      context,
      context.tr("Image removed successfully!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color underlineColor = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr("Pick a profile picture"),
            style: AppTextStyles.poppinsBlack(context, 30),
          ),
          const VerticalGap(16),
          Text(
            context.tr("Have a favorite selfie? Upload it now."),
            style: AppTextStyles.poppinsRegular(context, 18).copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const VerticalGap(48),
          Skeletonizer(
            enabled: _isPickedImageLoading,
            child: GestureDetector(
              onTap: _onAddImagePressed,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors.highlightBackgroundColor,
                      child: fileImage == null
                          ? const Icon(
                              Icons.person_2,
                              size: 140,
                              color: Colors.grey,
                            )
                          : ClipOval(
                              child: Image.file(
                                fileImage!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Visibility(
                      visible: fileImage != null,
                      child: Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: _onRemoveImagePressed,
                          child: const CustomBackgroundIcon(
                            iconData: Icons.close,
                            iconColor: Colors.white,
                            backgroundColor: AppColors.primary,
                            iconSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: fileImage == null,
                      child: const Positioned(
                        bottom: 15,
                        right: 15,
                        child: CustomBackgroundIcon(
                          iconData: Icons.add,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          iconSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          CustomTriggerButton(
            onPressed: _onSaveAndProceedButtonPressed,
            buttonDescription: Text(
              context.tr("Save & Proceed"),
              style: AppTextStyles.poppinsBold(context, 18).copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor:
                !_isImageUploaded ? AppColors.unEnabledButtonColor : null,
          ),
          const VerticalGap(16),
          Center(
            child: GestureDetector(
              onTap: _onSkipForNowButtonPressed,
              child: Text(
                context.tr("Skip for now"),
                style: AppTextStyles.poppinsBold(context, 20).copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: underlineColor,
                  decorationThickness: 2,
                ),
              ),
            ),
          ),
          const VerticalGap(AppConstants.bottomPadding),
        ],
      ),
    );
  }
}
