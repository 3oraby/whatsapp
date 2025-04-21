import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'resend_otp_state.dart';

class ResendOtpCubit extends BaseCubit<ResendOtpState> {
  ResendOtpCubit({required this.authRepo}) : super(ResendOtpInitial());

  final AuthRepo authRepo;

  Future<void> resendOtp({
    required String email,
  }) async {
    emit(ResendOtpLoadingState());
    final result = await authRepo.resendOtp(
      email: email,
    );
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(ResendOtpFailureState(message: failure.message!));
      },
      (_) => emit(ResendOtpLoadedState()),
    );
  }
}
