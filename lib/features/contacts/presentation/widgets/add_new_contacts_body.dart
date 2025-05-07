import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/search_in_users_cubit/search_in_users_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/contacts_search_results_list.dart';

class AddNewContactsBody extends StatefulWidget {
  const AddNewContactsBody({super.key});

  @override
  State<AddNewContactsBody> createState() => _AddNewContactsBodyState();
}

class _AddNewContactsBodyState extends State<AddNewContactsBody> {
  late final TextEditingController _searchController;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    final String query = _searchController.text;
    log("onSearchChanged, new query => $query");
    setState(() => _showClearButton = query.isNotEmpty);
    BlocProvider.of<SearchInUsersCubit>(context).searchInUsers(query: query);
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppPadding(
      child: Column(
        children: [
          CustomTextFormFieldWidget(
            controller: _searchController,
            hintText: "Search for users...",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _showClearButton
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: const Icon(Icons.clear),
                  )
                : null,
            contentPadding: 16,
            textStyle: AppTextStyles.poppinsBold(context, 16),
            hintStyle: AppTextStyles.poppinsBold(context, 16).copyWith(
              color: Colors.grey[500],
            ),
            autofocus: true,
          ),
          const VerticalGap(36),
          const Expanded(
            child: ContactsSearchResultsList(),
          ),
        ],
      ),
    );
  }
}
