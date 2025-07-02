import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/helpers/show_success_auth_modal_bottom_sheet.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/network_connection_listener_widget.dart';
import 'package:whatsapp/core/widgets/custom_modal_progress_hud.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:whatsapp/features/auth/presentation/cubits/signin_cubits/sign_in_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/signin_body.dart';
import 'package:whatsapp/features/chats/presentation/cubits/socket_connection_cubit/socket_connection_cubit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: NetworkConnectionListenerWidget(
        child: Scaffold(
          body: const SignInBLocConsumerBody(),
        ),
      ),
    );
  }
}

class SignInBLocConsumerBody extends StatelessWidget {
  const SignInBLocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is SignInLoadedState) {
          log("account successfully logged in");
          BlocProvider.of<SocketConnectionCubit>(context).connect();
          showSuccessAuthModalBottomSheet(
            context: context,
            sheetTitle: context.tr("Welcome Back! 🎉"),
            sheetDescription: context.tr(
                "You’ve logged in successfully. Start exploring tweets, connecting with friends, and sharing your thoughts instantly."),
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
        return CustomModalProgressHUD(
          inAsyncCall: state is SignInLoadingState,
          child: const SignInBody(),
        );
      },
    );
  }
}
