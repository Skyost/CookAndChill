import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension LightenDarkenColor on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension DateTimeFormat on DateTime {
  String formatDayMonth(BuildContext context) => DateFormat.MMMMEEEEd(EzLocalization.of(context)!.locale.languageCode).format(this).capitalize;
}

extension StringCapitalize on String {
  String get capitalize {
    if (isEmpty || length == 1) {
      return toUpperCase();
    }

    return this[0].toUpperCase() + substring(1);
  }
}
