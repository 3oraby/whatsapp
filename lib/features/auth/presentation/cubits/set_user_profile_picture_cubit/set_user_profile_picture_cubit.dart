import 'dart:io';

import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

part 'set_user_profile_picture_state.dart';

class SetUserProfilePictureCubit extends BaseCubit<SetUserProfilePictureState> {
  SetUserProfilePictureCubit({
    required this.authRepo,
  }) : super(SetUserProfilePictureInitial());

  final AuthRepo authRepo;

  Future<void> uploadUserProfileImg({
    required File mediaFile,
  }) async {
    emit(SetUserProfilePictureLoadingState());
    final result = await authRepo.uploadUserProfileImg(image: mediaFile);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(SetUserProfilePictureFailureState(message: failure.message!));
      },
      (mediaUrl) {
        emit(SetUserProfilePictureLoadedState(
          imageUrl: mediaUrl,
        ));
      },
    );
  }
}
