import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/internet/internet_connection_cubit.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_user_chats_body.dart';

class UserChatsView extends StatelessWidget {
  const UserChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetConnectionCubit, InternetConnectionState>(
      builder: (context, state) => Column(
        children: [
          AppBar(
            title: state is InternetConnectionDisconnected
                ? Text(
                    "Reconnecting..",
                    style: AppTextStyles.poppinsMedium(context, 18).copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                : null,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Theme.of(context).iconTheme.color,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.addNewContactsRoute);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                  size: 36,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const Expanded(
            child: ShowUserChatsBody(),
          )
        ],
      ),
    );
  }
}
