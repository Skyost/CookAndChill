import 'package:cookandchill/widgets/styled/background.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

class CookAndChillAlertDialog extends StatelessWidget {
  static const _contentPadding = EdgeInsets.fromLTRB(24, 20, 24, 24);

  final String titleKey;
  final String? emptyKey;
  final List<Widget> children;
  final List<Widget>? actions;
  final Widget? bottomButton;

  const CookAndChillAlertDialog({
    Key? key,
    required this.titleKey,
    this.emptyKey,
    required this.children,
    this.actions,
    this.bottomButton,
  }) : super(
          key: key,
        );

  CookAndChillAlertDialog.oneChild({
    Key? key,
    required String titleKey,
    required Widget child,
    List<Widget>? actions,
  }) : this(
          key: key,
          titleKey: titleKey,
          children: [child],
          actions: actions,
        );

  @override
  Widget build(BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        contentPadding: children.isEmpty ? _contentPadding : EdgeInsets.zero,
        title: Container(
          color: Colors.red,
          child: Stack(
            children: [
              const Positioned.fill(child: StyledBackground()),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  context.getString(titleKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _createChildWidget(context),
        ),
        actions: actions,
      );

  Widget _createChildWidget(BuildContext context) {
    List<Widget> children = [];
    if (this.children.isEmpty && emptyKey != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          context.getString(emptyKey!),
          style: const TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ));
    }

    children.addAll(this.children);

    if (bottomButton != null) {
      children.add(bottomButton!);
    }

    return ListView(
      shrinkWrap: true,
      padding: _contentPadding,
      children: children,
    );
  }
}
