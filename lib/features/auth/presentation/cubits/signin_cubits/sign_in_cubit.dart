
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.authRepo}) : super(SignInInitial());

  final AuthRepo authRepo;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(SignInLoadingState());
    final result = await authRepo.signInWithEmailAndPassword(
        email: email, password: password);
    result.fold(
      (failure) => emit(SignInFailureState(message: failure.errModel.errorMessage)),
      (userEntity) => emit(SignInLoadedState()),
    );
  }
}
