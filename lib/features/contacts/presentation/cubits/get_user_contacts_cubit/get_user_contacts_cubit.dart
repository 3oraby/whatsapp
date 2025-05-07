import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';

part 'get_user_contacts_state.dart';

class GetUserContactsCubit extends BaseCubit<GetUserContactsState> {
  GetUserContactsCubit({required this.contactsRepo})
      : super(GetUserContactsInitial());

  final ContactsRepo contactsRepo;

  Future<void> getUserContacts() async {
    emit(GetUserContactsLoadingState());
    final result = await contactsRepo.getUserContacts();
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(GetUserContactsFailureState(message: failure.message!));
      },
      (users) {
        if (users.isEmpty) {
          emit(GetUserContactsEmptyState());
        } else {
          emit(GetUserContactsLoadedState(users: users));
        }
      },
    );
  }
}
