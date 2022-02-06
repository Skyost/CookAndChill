import 'package:cookandchill/model/conditions/condition.dart';
import 'package:cookandchill/model/menu_model.dart';

class LunchCondition with Condition {
  static const id = 'lunch';

  @override
  bool isMet(MealDateTime date) => date.lunch;

  @override
  String get identifier => id;
}

class NotLunchCondition extends LunchCondition {
  static const id = '${LunchCondition.id}.not';

  @override
  bool isMet(MealDateTime date) => !super.isMet(date);

  @override
  String get identifier => id;
}
