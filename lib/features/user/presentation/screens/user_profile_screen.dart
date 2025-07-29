// lib/features/user/presentation/pages/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class UserProfileScreen extends StatelessWidget {
  final UserEntity user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VerticalGap(24),
          BuildUserProfileImage(
            circleAvatarRadius: 60,
            userEntity: user,
            profilePicUrl: user.profileImage,
          ),
          const VerticalGap(16),
          Text(user.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const VerticalGap(8),
          Text(user.phoneNumber ?? "Number",
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const VerticalGap(16),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text("Email"),
            subtitle: Text(user.email),
          ),
          const VerticalGap(16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            subtitle: Text(
              "Hey there! I am using WhatsApp.",
            ),
          ),
        ],
      ),
    );
  }
}
