import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.authRepo}) : super(SignUpInitial());
  final AuthRepo authRepo;

  Future<void> signUp({
    required Map<String, dynamic> data,
  }) async {
    emit(SignUpLoadingState());
    // final result = await authRepo.createUserWithEmailAndPassword(
    //     email: email, password: password);
    // result.fold(
    //   (failure) => emit(SignUpFailureState(message: failure.message)),
    //   (userEntity) => emit(SignUpLoadedState()),
    // );
  }
}
