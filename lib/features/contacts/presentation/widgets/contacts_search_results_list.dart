import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/widgets/custom_empty_state_body.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/search_in_users_cubit/search_in_users_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/show_users_list_view.dart';

class ContactsSearchResultsList extends StatelessWidget {
  const ContactsSearchResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchInUsersCubit, SearchInUsersState>(
      builder: (context, state) {
        if (state is SearchInUsersLoadingState) {
          return CustomLoadingBodyWidget();
        } else if (state is SearchInUsersFailureState) {
          return CustomErrorBodyWidget(
            errorMessage: state.message,
            onRetry: () {
              BlocProvider.of<SearchInUsersCubit>(context).searchInUsers();
            },
          );
        } else if (state is SearchInUsersLoadedState) {
          return ShowUsersListView(
            users: state.users,
          );
        } else if (state is SearchInUsersEmptyState) {
          return const CustomEmptyStateBody(
            title: "No users found",
            icon: Icons.person_search,
          );
        }
        return SizedBox();
      },
    );
  }
}
