import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';

abstract class ContactsRepo {
  Future<Either<Failure, List<UserWithContactStatusEntity>>> searchInUsers({
    String? query,
  });

  Future<Either<Failure, void>> createNewContact({required int userId});

  Future<Either<Failure, List<UserWithContactStatusEntity>>> getUserContacts();
}
