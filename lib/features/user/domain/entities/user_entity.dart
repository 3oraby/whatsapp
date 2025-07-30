class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? description;
  final String? profileImage;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.description,
    this.profileImage,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? description,
    String? profileImage,
    bool removeProfileImage = false,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      profileImage:
          removeProfileImage ? null : profileImage ?? this.profileImage,
    );
  }
}
