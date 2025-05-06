import 'package:flutter/material.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/custom_user_info_card.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';

class ShowUsersListView extends StatelessWidget {
  const ShowUsersListView({
    super.key,
    required this.users,
  });

  final List<UserWithContactStatusEntity> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const VerticalGap(32),
      itemBuilder: (context, index) => CustomUserInfoCard(
        user: users[index].user,
        currentUserId: 100,
        isActiveButton: users[index].isContact ?? false,
      ),
    );
  }
}
