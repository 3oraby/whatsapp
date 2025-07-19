import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/logout_cubit/logout_cubit.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_logout_button.dart';
import 'package:whatsapp/core/widgets/custom_modal_progress_hud.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/custom_user_info_card.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: SettingsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity()!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogOutFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is LogoutLoadedState) {
          showCustomSnackBar(context, "Logged out successfully");
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signInRoute,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is LogoutLoadingState,
          child: CustomAppPadding(
            child: Column(
              children: [
                const VerticalGap(60),
                CustomUserInfoCard(
                  user: currentUser,
                  currentUserId: currentUser.id,
                ),
                Expanded(
                  child: Center(
                    child: CustomLogOutButton(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
