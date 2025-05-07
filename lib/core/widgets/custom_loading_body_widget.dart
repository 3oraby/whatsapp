import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';

class CustomLoadingBodyWidget extends StatelessWidget {
  final String loadingMessage;

  const CustomLoadingBodyWidget({
    super.key,
    this.loadingMessage = "Loading..",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const VerticalGap(16),
          Text(
            loadingMessage,
            style: AppTextStyles.poppinsMedium(context, 18).copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
