import 'package:cookandchill/model/settings_model.dart';
import 'package:cookandchill/widgets/styled/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StyledActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const StyledActionButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              top: -16,
              left: -16,
              right: -16,
              bottom: -16,
              child: StyledBackground(),
            ),
            child,
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        onPressed: onPressed,
      );
}
