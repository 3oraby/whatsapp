import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends BaseCubit<SignInState> {
  SignInCubit({required this.authRepo}) : super(SignInInitial());

  final AuthRepo authRepo;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(SignInLoadingState());
    final result = await authRepo.signInWithEmailAndPassword(
        email: email, password: password);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(SignInFailureState(message: failure.message!));
      },
      (_) => emit(SignInLoadedState()),
    );
  }
}
