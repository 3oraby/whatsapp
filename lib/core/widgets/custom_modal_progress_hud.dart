import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:whatsapp/core/utils/app_colors.dart';

class CustomModalProgressHUD extends StatelessWidget {
  const CustomModalProgressHUD({
    super.key,
    required this.inAsyncCall,
    required this.child,
    this.indicatorColor = AppColors.primary,
  });

  final bool inAsyncCall;
  final Widget child;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
      child: child,
    );
  }
}
