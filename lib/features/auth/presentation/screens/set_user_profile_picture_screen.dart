import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/helpers/show_success_auth_modal_bottom_sheet.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/custom_modal_progress_hud.dart';
import 'package:whatsapp/features/auth/presentation/cubits/set_user_profile_picture_cubit/set_user_profile_picture_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/set_user_profile_picture_body.dart';

class SetUserProfilePictureScreen extends StatelessWidget {
  const SetUserProfilePictureScreen({
    super.key,
    this.isInSignUpStep = true,
  });

  final bool isInSignUpStep;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SetUserProfilePictureBlocConsumerBody(
        isInSignUpStep: isInSignUpStep,
      ),
    );
  }
}

class SetUserProfilePictureBlocConsumerBody extends StatelessWidget {
  const SetUserProfilePictureBlocConsumerBody({
    super.key,
    required this.isInSignUpStep,
  });

  final bool isInSignUpStep;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUserProfilePictureCubit, SetUserProfilePictureState>(
      listener: (context, state) {
        if (state is SetUserProfilePictureFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is SetUserProfilePictureLoadedState) {
          log("image uploaded successfully");
          if (isInSignUpStep) {
            showSuccessAuthModalBottomSheet(
              context: context,
              sheetTitle: context.tr("Profile Picture Uploaded! 🎉"),
              sheetDescription: context.tr(
                  "Your profile picture is set! You're all ready to start chatting and stay connected with your friends."),
              buttonDescription: context.tr('Go to Chats'),
              onNextButtonPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.homeRoute,
                  (Route<dynamic> route) => false,
                );
              },
            );
          } else {
            Navigator.pop(context);
            showCustomSnackBar(
              context,
              context.tr("Profile Picture Uploaded! 🎉"),
              backgroundColor: Colors.black,
            );
          }
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: CustomModalProgressHUD(
            inAsyncCall: state is SetUserProfilePictureLoadingState,
            child: const SetUserProfilePictureBody(),
          ),
        );
      },
    );
  }
}
