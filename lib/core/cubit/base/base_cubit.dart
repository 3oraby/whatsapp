import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/main.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  void handleFailure(Failure failure) {
    log("handle failure in base cubit.. , failure is : ${failure.message.toString()}");
    if (failure is UnAuthorizedException) {
      log("failure in base cubit: 'unAuthorizedException'");
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.signInRoute,
        (_) => false,
      );
    }
  }
}
