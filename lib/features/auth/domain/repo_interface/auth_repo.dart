import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, void>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, void>> logOut();
}
