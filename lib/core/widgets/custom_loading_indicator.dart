import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      indicatorType: Indicator.ballPulse,
      colors: [
        isLightTheme(context) ? Colors.black : Colors.white,
      ],
      strokeWidth: 2,
    );
  }
}
