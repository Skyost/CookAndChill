import 'package:cookandchill/model/conditions/condition.dart';
import 'package:cookandchill/model/menu_model.dart';

class DayOfWeekCondition with Condition {
  static const id = 'dayOfWeek';

  int dayOfWeek;

  DayOfWeekCondition({
    required this.dayOfWeek,
  });

  DayOfWeekCondition.fromJson(Map<String, dynamic> json)
      : this(
          dayOfWeek: json['dayOfWeek'],
        );

  @override
  bool isMet(MealDateTime date) {
    DateTime dateTime = DateTime(date.year, date.month, date.day);
    return dateTime.weekday == dayOfWeek;
  }

  @override
  String get identifier => id;

  @override
  Map<String, dynamic> toJson() => super.toJson()..['dayOfWeek'] = dayOfWeek;
}

class NotDayOfWeekCondition extends DayOfWeekCondition {
  static const id = '${DayOfWeekCondition.id}.not';

  NotDayOfWeekCondition({
    required int dayOfWeek,
  }) : super(
          dayOfWeek: dayOfWeek,
        );

  NotDayOfWeekCondition.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  bool isMet(MealDateTime date) => !super.isMet(date);

  @override
  String get identifier => id;
}
