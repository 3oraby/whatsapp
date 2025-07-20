import 'dart:io';

import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';

part 'upload_chat_image_state.dart';

class UploadChatImageCubit extends BaseCubit<UploadChatImageState> {
  UploadChatImageCubit({
    required this.chatsRepo,
  }) : super(UploadChatImageInitial());

  final ChatsRepo chatsRepo;

  Future<void> uploadChatImage({
    required File mediaFile,
  }) async {
    emit(UploadChatImageLoadingState());
    final result = await chatsRepo.uploadChatImage(image: mediaFile);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(UploadChatImageFailureState(message: failure.message!));
      },
      (mediaUrl) {
        emit(UploadChatImageLoadedState(
          mediaUrl: mediaUrl,
        ));
      },
    );
  }
}
