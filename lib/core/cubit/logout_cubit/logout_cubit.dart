import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'logout_state.dart';

class LogoutCubit extends BaseCubit<LogoutState> {
  LogoutCubit({required this.authRepo}) : super(LogoutInitial());

  final AuthRepo authRepo;

  Future<void> logOut() async {
    emit(LogoutLoadingState());
    final result = await authRepo.logOut();
    result.fold(
      (failure) => emit(LogOutFailureState(message: failure.message!)),
      (success) => emit(LogoutLoadedState()),
    );
  }
}
