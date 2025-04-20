import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> signUp({
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, void>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, void>> verifyOtp(
      {required String email, required String otp});

  Future<Either<Failure, void>> logOut();
}
