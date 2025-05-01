import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';

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
      child: ListView.separated(
        itemCount: widget.users.length,
        separatorBuilder: (context, index) => const VerticalGap(24),
        itemBuilder: (context, index) => Container(
          color: AppColors.primary,
          height: 100,
          child: Text(widget.users[index].user.email),
        ),
      ),
    );
  }
}
