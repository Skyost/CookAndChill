import 'package:cookandchill/model/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StyledBackground extends StatelessWidget {
  const StyledBackground({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    SettingsModel settingsModel = context.watch<SettingsModel>();
    switch (settingsModel.style) {
      case AppStyle.italian:
        return Opacity(
          opacity: 0.4,
          child: Image.asset(
            'assets/images/background.png',
            repeat: ImageRepeat.repeat,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
