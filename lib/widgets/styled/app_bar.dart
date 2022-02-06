import 'package:cookandchill/model/settings_model.dart';
import 'package:cookandchill/widgets/styled/background.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StyledAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? titleKey;
  final Color? backgroundColor;
  final Color? shadowColor;
  final List<Widget>? actions;

  const StyledAppBar({
    Key? key,
    this.titleKey,
    this.backgroundColor,
    this.shadowColor,
    this.actions,
  }) : super(
          key: key,
        );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: titleKey == null ? null : Text(context.getString(titleKey!)),
        backgroundColor: backgroundColor,
        shadowColor: shadowColor,
        flexibleSpace: backgroundColor == null || backgroundColor != Colors.transparent ? const StyledBackground() : null,
        centerTitle: true,
        actions: actions,
      );
}
