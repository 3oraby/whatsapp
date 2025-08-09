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
import 'package:whatsapp/features/auth/presentation/cubits/resend_otp_cubit/resend_otp_cubit.dart';
import 'package:whatsapp/features/auth/presentation/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/verify_otp_body.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ResendOtpCubit(
            authRepo: getIt<AuthRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => VerifyOtpCubit(
            authRepo: getIt<AuthRepo>(),
          ),
        ),
      ],
      child: Scaffold(
        body: const VerifyOtpBlocConsumerBody(),
      ),
    );
  }
}

class VerifyOtpBlocConsumerBody extends StatelessWidget {
  const VerifyOtpBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is VerifyOtpLoadedState) {
          log("account successfully logged in");
          showSuccessAuthModalBottomSheet(
            context: context,
            sheetTitle: context.tr("Welcome Back! 🎉"),
            sheetDescription: context.tr(
                "Your account is ready. Next, choose your profile picture, then start chatting and sharing moments with your friends instantly."),
            buttonDescription: context.tr('Explore Now'),
            onNextButtonPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.setUserProfileImgRoute,
                (Route<dynamic> route) => false,
              );
            },
          );
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is VerifyOtpLoadingState,
          child: const VerifyOtpBody(),
        );
      },
    );
  }
}
