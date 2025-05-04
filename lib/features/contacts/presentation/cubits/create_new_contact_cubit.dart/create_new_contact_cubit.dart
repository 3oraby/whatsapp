import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';

part 'create_new_contact_state.dart';

class CreateNewContactCubit extends BaseCubit<CreateNewContactState> {
  CreateNewContactCubit({required this.contactsRepo})
      : super(CreateNewContactInitial());

  final ContactsRepo contactsRepo;

  Future<void> createNewContact({required int userId}) async {
    emit(CreateNewContactLoadingState());
    final result = await contactsRepo.createNewContact(userId: userId);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(CreateNewContactFailureState(message: failure.message!));
      },
      (_) => emit(CreateNewContactLoadedState()),
    );
  }
}
