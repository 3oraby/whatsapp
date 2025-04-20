import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends BaseCubit<VerifyOtpState> {
  VerifyOtpCubit({required this.authRepo}) : super(VerifyOtpInitial());
  final AuthRepo authRepo;

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(VerifyOtpLoadingState());
    final result = await authRepo.verifyOtp(
      email: email,
      otp: otp,
    );
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(VerifyOtpFailureState(message: failure.message!));
      },
      (userEntity) => emit(VerifyOtpLoadedState()),
    );
  }
}
