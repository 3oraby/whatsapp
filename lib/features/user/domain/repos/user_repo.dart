import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/user/domain/entities/user_current_status_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, UserCurrentStatusEntity>> getUserCurrentStatus({
    required int userId,
  });
}
