import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_empty_state_body.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/get_user_contacts_cubit/get_user_contacts_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/show_users_list_view.dart';

class GetUserContactsBody extends StatefulWidget {
  const GetUserContactsBody({super.key});

  @override
  State<GetUserContactsBody> createState() => _GetUserContactsBodyState();
}

class _GetUserContactsBodyState extends State<GetUserContactsBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetUserContactsCubit>(context).getUserContacts();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppPadding(
      child: BlocBuilder<GetUserContactsCubit, GetUserContactsState>(
        builder: (context, state) {
          if (state is GetUserContactsLoadingState) {
            return CustomLoadingBodyWidget();
          } else if (state is GetUserContactsFailureState) {
            return CustomErrorBodyWidget(
              errorMessage: state.message,
              onRetry: () {
                BlocProvider.of<GetUserContactsCubit>(context)
                    .getUserContacts();
              },
            );
          } else if (state is GetUserContactsLoadedState) {
            return ShowUsersListView(
              users: state.users,
            );
          } else if (state is GetUserContactsEmptyState) {
            return const CustomEmptyStateBody(
              title: "No users found",
              icon: Icons.person_search,
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
