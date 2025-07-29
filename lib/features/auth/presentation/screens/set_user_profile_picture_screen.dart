import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/helpers/show_success_auth_modal_bottom_sheet.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/custom_modal_progress_hud.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:whatsapp/features/auth/presentation/cubits/set_user_profile_picture_cubit/set_user_profile_picture_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/set_user_profile_picture_body.dart';

class SetUserProfilePictureScreen extends StatefulWidget {
  const SetUserProfilePictureScreen({super.key});


  @override
  State<SetUserProfilePictureScreen> createState() =>
      _SetUserProfilePictureScreenState();
}

class _SetUserProfilePictureScreenState
    extends State<SetUserProfilePictureScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetUserProfilePictureCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: Scaffold(
        body: const SetUserProfilePictureBlocConsumerBody(),
      ),
    );
  }
}

class SetUserProfilePictureBlocConsumerBody extends StatelessWidget {
  const SetUserProfilePictureBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUserProfilePictureCubit, SetUserProfilePictureState>(
      listener: (context, state) {
        if (state is SetUserProfilePictureFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is SetUserProfilePictureLoadedState) {
          log("image uploaded successfully");
          showSuccessAuthModalBottomSheet(
            context: context,
            sheetTitle: context.tr("Profile Picture Uploaded! 🎉"),
            sheetDescription: context.tr(
                "Your profile picture has been uploaded successfully. You're all set to explore tweets and connect with friends!"),
            buttonDescription: context.tr('Explore Now'),
            onNextButtonPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.homeRoute,
                (Route<dynamic> route) => false,
              );
            },
          );
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
