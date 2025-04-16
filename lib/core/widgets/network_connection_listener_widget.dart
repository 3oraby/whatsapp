import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/internet/internet_connection_cubit.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';

class NetworkConnectionListenerWidget extends StatelessWidget {
  final Widget child;

  const NetworkConnectionListenerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      listener: (context, state) {
        if (state is InternetConnectionDisconnected) {
          showCustomSnackBar(
            context,
            "Reconnecting..",
            durationDay: 1,
            showCloseIcon: false,
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
      child: child,
    );
  }
}
