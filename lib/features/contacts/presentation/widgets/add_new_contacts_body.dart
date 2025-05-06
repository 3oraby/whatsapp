import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/show_users_list_view.dart';

class AddNewContactsBody extends StatefulWidget {
  const AddNewContactsBody({
    super.key,
    required this.users,
  });

  final List<UserWithContactStatusEntity> users;
  @override
  State<AddNewContactsBody> createState() => _AddNewContactsBodyState();
}

class _AddNewContactsBodyState extends State<AddNewContactsBody> {
  @override
  Widget build(BuildContext context) {
    return CustomAppPadding(
      child: Column(
        children: [
          CustomTextFormFieldWidget(
            contentPadding: 0,
          ),
          const VerticalGap(36),
          Expanded(
            child: ShowUsersListView(users: widget.users),
          ),
        ],
      ),
    );
  }
}
