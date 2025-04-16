import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/features/auth/domain/entities/user_entity.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  // final FirebaseAuthService firebaseAuthService;
  // final UserRepo userRepo;
  AuthRepoImpl(
      // {
      // required this.firebaseAuthService,
      // required this.userRepo,
      // }
      );

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({required String email, required String password}) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final result = await api.post(
  //       EndPoints.login,
  //       data: {
  //         "email": email,
  //         "password": password,
  //       },
  //     );
  //     final user = UserModel.fromJson(result);
  //     return Right(user);
  //   } on UnAuthorizedException {
  //     return Left(UnAuthorizedException());
  //   } on ServerException catch (e) {
  //     return Left(ServerException(errModel: e.errModel));
  //   }
  // }

  // @override
  // Future<Either<Failure, User>> createUserWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   try {
  //     User user = await firebaseAuthService.createUserWithEmailAndPassword(
  //         email: email, password: password);

  //     return right(user);
  //   } catch (e) {
  //     return left(ServerFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, User>> signInWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   try {
  //     User user = await firebaseAuthService.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     await userRepo.getCurrentUserData();
  //     return right(user);
  //   } catch (e) {
  //     return left(ServerFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> logOut() async {
  //   try {
  //     await firebaseAuthService.logOut();
  //     await deleteUserDataFromPrefs();
  //     return right(Success());
  //   } catch (e) {
  //     return left(ServerFailure(message: e.toString()));
  //   }
  // }

}
