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
}
