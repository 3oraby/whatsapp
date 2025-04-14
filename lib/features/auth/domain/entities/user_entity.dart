
class UserEntity {
  final String userId;
  final String email;
  String? firstName;
  String? lastName;
  String? profilePicUrl;
  String? phoneNumber;
  final DateTime joinedAt;

  UserEntity({
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.profilePicUrl,
    this.phoneNumber,
    required this.joinedAt,
  });

  UserEntity copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePicUrl,
    String? phoneNumber,
    DateTime? joinedAt,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
