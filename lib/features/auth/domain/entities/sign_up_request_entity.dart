class SignUpRequestEntity {
  final String name;
  final String email;
  final String password;
  final String phone;

  const SignUpRequestEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}
