import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends BaseCubit<SignUpState> {
  SignUpCubit({required this.authRepo}) : super(SignUpInitial());
  final AuthRepo authRepo;

  Future<void> signUp({
    required Map<String, dynamic> data,
  }) async {
    emit(SignUpLoadingState());
    final result = await authRepo.signUp(data: data);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(SignUpFailureState(message: failure.message!));
      },
      (userEntity) => emit(SignUpLoadedState()),
    );
  }
}
