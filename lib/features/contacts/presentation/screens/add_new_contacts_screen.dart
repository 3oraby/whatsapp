import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/leading_arrow_back.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/search_in_users_cubit/search_in_users_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/add_new_contacts_body.dart';

class AddNewContactsScreen extends StatelessWidget {
  const AddNewContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchInUsersCubit(
        contactsRepo: getIt<ContactsRepo>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: LeadingArrowBack(),
          centerTitle: true,
          title: Text(
            "Add Friends",
            style: AppTextStyles.poppinsBold(context, 22),
          ),
        ),
        body: AddNewContactsBlocConsumerBody(),
      ),
    );
  }
}



class AddNewContactsBlocConsumerBody extends StatefulWidget {
  const AddNewContactsBlocConsumerBody({super.key});

  @override
  State<AddNewContactsBlocConsumerBody> createState() =>
      _AddNewContactsBlocConsumerBodyState();
}

class _AddNewContactsBlocConsumerBodyState
    extends State<AddNewContactsBlocConsumerBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchInUsersCubit>(context).searchInUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchInUsersCubit, SearchInUsersState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SearchInUsersLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchInUsersFailureState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is SearchInUsersLoadedState) {
          return AddNewContactsBody(users: state.users);
        }
        return SizedBox();
      },
    );
  }
}
