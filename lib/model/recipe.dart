import 'dart:math';

import 'package:cookandchill/model/conditions/condition.dart';
import 'package:cookandchill/model/menu_model.dart';
import 'package:flutter/material.dart';

class Recipe with ChangeNotifier {
  String _image;
  String _name;
  int _maxMeals;
  List<Ingredient> _ingredients;
  List<Condition> _conditions;
  String? _recipe;

  Recipe({
    String image = 'hot',
    String name = 'Ma recette',
    int maxMeals = 1,
    List<Ingredient>? ingredients,
    List<Condition>? conditions,
    String? recipe,
  })  : _image = image,
        _name = name,
        _maxMeals = maxMeals,
        _ingredients = ingredients ?? [],
        _conditions = conditions ?? [],
        _recipe = recipe;

  Recipe.fromJson(Map<String, dynamic> json)
      : this(
          image: json['image'],
          name: json['name'],
    maxMeals: json['maxMeals'],
          ingredients: json['ingredients'].map<Ingredient>((ingredient) => Ingredient.fromJson(ingredient)).toList()..sort(),
          conditions: json['conditions'].map<Condition>((condition) => Condition.fromJson(condition)!).toList(),
          recipe: json['recipe'],
        );

  String get image => _image;

  void changeImage(String image, {bool notify = true}) {
    _image = image;
    if (notify) {
      notifyListeners();
    }
  }

  String get name => _name;

  void changeName(String name, {bool notify = true}) {
    _name = name;
    if (notify) {
      notifyListeners();
    }
  }

  int get maxMeals => _maxMeals;

  void changeMaxMeals(int maxMeals, {bool notify = true}) {
    _maxMeals = maxMeals;
    if (notify) {
      notifyListeners();
    }
  }

  List<Ingredient> get ingredients => List.from(_ingredients);

  void addIngredient(Ingredient ingredient, {bool notify = true}) {
    if (!_ingredients.contains(ingredient)) {
      _ingredients.add(ingredient);
      if (notify) {
        notifyListeners();
      }
    }
  }

  void removeIngredient(Ingredient ingredient, {bool notify = true}) {
    if (_ingredients.remove(ingredient) && notify) {
      notifyListeners();
    }
  }

  List<Condition> get conditions => List.from(_conditions);

  void addCondition(Condition condition, {bool notify = true}) {
    if (!_conditions.contains(condition)) {
      _conditions.add(condition);
      if (notify) {
        notifyListeners();
      }
    }
  }

  void removeCondition(Condition condition, {bool notify = true}) {
    if (_conditions.remove(condition) && notify) {
      notifyListeners();
    }
  }

  String? get recipe => _recipe;

  void changeRecipe(String? recipe, {bool notify = true}) {
    _recipe = recipe;
    if (notify) {
      notifyListeners();
    }
  }

  String get imageAsset => 'assets/recipes/$_image.png';

  void changeImageAsset(String imageAsset, {bool notify = true}) {
    if (imageAsset.contains('assets/recipes/')) {
      imageAsset = imageAsset.substring('assets/recipes/'.length);
    }
    if (imageAsset.endsWith('.png')) {
      imageAsset = imageAsset.substring(0, imageAsset.length - '.png'.length);
    }
    _image = imageAsset;
    if (notify) {
      notifyListeners();
    }
  }

  bool areConditionsMet(MealDateTime date) {
    for (Condition condition in _conditions) {
      if (!condition.isMet(date)) {
        return false;
      }
    }
    return true;
  }

  List<MealDateTime> getPossibleDates(List<MealDateTime> dates) {
    List<MealDateTime> result = dates.where(areConditionsMet).toList();
    return result.sublist(0, min(_maxMeals + 1, result.length));
  }

  Map<String, dynamic> toJson() => {
        'image': _image,
        'name': _name,
        'maxMeals': _maxMeals,
        'ingredients': _ingredients.map((ingredient) => ingredient.toJson()).toList(),
        'conditions': _conditions.map((condition) => condition.toJson()).toList(),
        'recipe': _recipe,
      };
}

class Ingredient with Comparable<Ingredient> {
  String name;
  int count;

  Ingredient({
    this.name = 'Ingrédient',
    this.count = 1,
  });

  Ingredient.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          count: json['count'],
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'count': count,
      };

  @override
  int compareTo(Ingredient other) => name.compareTo(other.name);

  Ingredient clone() => Ingredient(name: name, count: count);
}
