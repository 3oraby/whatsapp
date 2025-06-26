import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> signUp({
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> resendOtp({
    required String email,
  });

  Future<Either<Failure, void>> logOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
