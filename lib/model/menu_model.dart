import 'dart:math';

import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/model/recipe_model.dart';
import 'package:flutter/material.dart';

class MenuModel with ChangeNotifier {
  Map<MealDateTime, Recipe>? _menu;
  List<Ingredient>? _ingredients;

  int _mealCount = 10;

  int get mealCount => _mealCount;

  void changeMealCount(int mealCount, RecipeModel recipeModel, {bool notify = true}) {
    _mealCount = min(max(1, mealCount), recipeModel.maxMealCount);
    if (mealCount != _mealCount) {
      _mealCount = mealCount;
      if (notify) {
        notifyListeners();
      }
    }
  }

  bool get isMenuCrafted => _menu != null;

  List<Ingredient> get ingredients => List.of(_ingredients ?? []);

  List<MealDateTime> get dates => List.of(_menu?.keys ?? [])..sort();

  Recipe? getRecipeAt(MealDateTime date) => _menu?[date];

  void changeRecipeAt(MealDateTime date, Recipe recipe, {bool notify = true}) {
    _menu![date] = recipe;
    _calculateIngredients(notify: notify);
  }

  void resetMenu({bool notify = true}) {
    _menu = null;
    if (notify) {
      notifyListeners();
    }
  }

  void craftMenu(RecipeModel recipeModel, {bool notify = true}) {
    int mealCount = min(recipeModel.maxMealCount, _mealCount);
    List<Recipe> recipes = recipeModel.recipes;
    Map<MealDateTime, Recipe> result = {};

    MealDateTime now = MealDateTime.now();
    MealDateTime current = now;
    List<MealDateTime> dates = [];
    for (int i = 0; i < mealCount; i++) {
      dates.add(current);
      current = current.next;
    }

    while (result.length < mealCount) {
      Recipe? recipe = _getRandomBestRecipe(dates, recipes);
      if (recipe == null) {
        break;
      }
      List<MealDateTime> possibleDates = recipe.getPossibleDates(dates);
      for (MealDateTime possibleDate in possibleDates) {
        result[possibleDate] = recipe;
      }
      recipes.remove(recipe);
    }

    _menu = result;
    _calculateIngredients();
    if (notify) {
      notifyListeners();
    }
  }

  void _calculateIngredients({bool notify = true}) {
    List<Ingredient> ingredients = [];
    Set<String> ingredientsName = {};
    Set<Recipe> recipes = _menu!.values.toSet();
    for (Recipe recipe in recipes) {
      for (Ingredient recipeIngredient in recipe.ingredients) {
        if (ingredientsName.contains(recipeIngredient.name)) {
          Ingredient listIngredient = ingredients.firstWhere((ingredient) => ingredient.name == recipeIngredient.name);
          listIngredient.count += recipeIngredient.count;
        } else {
          ingredients.add(recipeIngredient.clone());
          ingredientsName.add(recipeIngredient.name);
        }
      }
    }
    _ingredients = ingredients..sort();
    if (notify) {
      notifyListeners();
    }
  }

  Recipe? _getRandomBestRecipe(List<MealDateTime> dates, List<Recipe> recipes) {
    int bestDateCount = 1;
    List<Recipe> result = [];
    for (Recipe recipe in recipes) {
      int recipeDateCount = 0;
      for (MealDateTime date in dates) {
        if (recipe.areConditionsMet(date)) {
          recipeDateCount++;
        }
      }
      if (recipeDateCount >= bestDateCount) {
        if (recipeDateCount > bestDateCount) {
          result = [];
        }
        result.add(recipe);
      }
    }
    return result.isEmpty ? null : result[Random().nextInt(result.length)];
  }
}

class MealDateTime with Comparable<MealDateTime> {
  static const _lunchHour = 11;
  static const _dinerHour = 23;

  final int year;
  final int month;
  final int day;
  final bool lunch;
  Season? _season;

  MealDateTime.now() : this.fromDate(DateTime.now());

  MealDateTime.fromDate(DateTime date)
      : this(
          year: date.year,
          month: date.month,
          day: date.day,
          lunch: date.hour >= 6 && date.hour <= 16,
        );

  MealDateTime({
    required this.year,
    required this.month,
    required this.day,
    required this.lunch,
  });

  Season get season {
    if (_season == null) {
      if (DateTime.march <= month && 20 <= day && month <= DateTime.june && day <= 20) {
        _season = Season.spring;
      } else if (DateTime.june <= month && 21 <= day && month <= DateTime.september && day <= 22) {
        _season = Season.summer;
      } else if (DateTime.september <= month && 23 <= day && month <= DateTime.december && day <= 20) {
        _season = Season.autumn;
      } else {
        _season = Season.winter;
      }
    }
    return _season!;
  }

  DateTime toDateTime() => DateTime(year, month, day, lunch ? _lunchHour : _dinerHour);

  MealDateTime get next => MealDateTime.fromDate(toDateTime().add(const Duration(hours: 12)));

  @override
  int compareTo(MealDateTime other) {
    int result;

    result = year - other.year;
    if (result != 0) {
      return result;
    }

    result = month - other.month;
    if (result != 0) {
      return result;
    }

    result = day - other.day;
    if (result != 0) {
      return result;
    }

    result = (lunch ? _lunchHour : _dinerHour) - (other.lunch ? _lunchHour : _dinerHour);
    if (result != 0) {
      return result;
    }

    return result;
  }
}

enum Season {
  spring,
  summer,
  autumn,
  winter,
}
