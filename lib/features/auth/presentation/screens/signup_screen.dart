import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/custom_modal_progress_hud.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:whatsapp/features/auth/presentation/cubits/signup_cubits/sign_up_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: Scaffold(
        body: const SignUpBlocConsumerBody(),
      ),
    );
  }
}

class SignUpBlocConsumerBody extends StatelessWidget {
  const SignUpBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is SignUpLoadedState) {
          log("account successfully created");
          showCustomSnackBar(
              context, "A verification code has been sent to your email.");
          Navigator.pushNamed(
            context,
            Routes.verifyOtpRoute,
          );
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is SignUpLoadingState,
          child: const SignUpBody(),
        );
      },
    );
  }
}
