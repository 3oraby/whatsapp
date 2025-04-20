import 'package:whatsapp/features/auth/domain/entities/sign_up_request_entity.dart';

class SignUpRequestModel extends SignUpRequestEntity {
  const SignUpRequestModel({
    required super.name,
    required super.email,
    required super.password,
    required super.phone,
  });

  factory SignUpRequestModel.fromEntity(SignUpRequestEntity entity) {
    return SignUpRequestModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      phone: entity.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phone_number": phone,
    };
  }

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    return SignUpRequestModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}
