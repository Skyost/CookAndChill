import 'package:cookandchill/model/conditions/condition.dart';
import 'package:cookandchill/model/menu_model.dart';
import 'package:flutter/material.dart';

class SeasonCondition with Condition {
  static const id = 'season';

  Season season;

  SeasonCondition({
    required this.season,
  });

  SeasonCondition.fromJson(Map<String, dynamic> json)
      : this(
          season: Season.values[json['season']],
        );

  @override
  bool isMet(MealDateTime date) => date.season == season;

  @override
  Map<String, dynamic> toJson() => super.toJson()..['season'] = season.index;

  @override
  String get identifier => id;
}

class NotSeasonCondition extends SeasonCondition {
  static const id = '${SeasonCondition.id}.not';

  NotSeasonCondition({
    required Season season,
  }) : super(season: season);

  NotSeasonCondition.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  bool isMet(MealDateTime date) => !super.isMet(date);

  @override
  String get identifier => id;
}
