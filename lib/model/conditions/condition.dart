import 'package:cookandchill/model/conditions/day_of_week.dart';
import 'package:cookandchill/model/conditions/lunch.dart';
import 'package:cookandchill/model/conditions/season.dart';
import 'package:cookandchill/model/menu_model.dart';
import 'package:cookandchill/model/recipe_model.dart';

abstract class Condition {
  static Condition? fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id')) {
      return null;
    }
    switch(json['id']) {
      case DayOfWeekCondition.id:
        return DayOfWeekCondition.fromJson(json);
      case NotDayOfWeekCondition.id:
        return NotDayOfWeekCondition.fromJson(json);
      case LunchCondition.id:
        return LunchCondition();
      case NotLunchCondition.id:
        return NotLunchCondition();
      case SeasonCondition.id:
        return SeasonCondition.fromJson(json);
      case NotSeasonCondition.id:
        return NotSeasonCondition.fromJson(json);
    }
    return null;
  }

  bool isMet(MealDateTime date);

  String get identifier;

  Map<String, dynamic> toJson() => {
    'id': identifier
  };
}

