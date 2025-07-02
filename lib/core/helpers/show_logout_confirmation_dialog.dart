import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/logout_cubit/logout_cubit.dart';
import 'package:whatsapp/core/helpers/show_custom_alert_dialog.dart';
import 'package:whatsapp/features/chats/presentation/cubits/socket_connection_cubit/socket_connection_cubit.dart';

void showLogoutConfirmationDialog({
  required BuildContext context,
}) {
  showCustomAlertDialog(
    context: context,
    title: context.tr("Are you sure?"),
    content: context.tr("Do you really want to log out?"),
    okButtonDescription: context.tr("Log Out"),
    onCancelButtonPressed: () {
      Navigator.pop(context);
    },
    onOkButtonPressed: () {
      BlocProvider.of<SocketConnectionCubit>(context).disconnect();
      BlocProvider.of<LogoutCubit>(context).logOut();
    },
  );
}
