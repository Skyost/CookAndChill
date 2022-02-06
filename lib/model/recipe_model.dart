import 'dart:convert';
import 'dart:math';

import 'package:cookandchill/model/storable_model.dart';
import 'package:cookandchill/model/storage/storage.dart';
import 'package:cookandchill/model/recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeModel extends StorableModel {
  @override
  String get file => '.recipes';

  List<Recipe> _recipes = [];

  List<Recipe> get recipes => List.from(_recipes);

  @override
  void loadJson(Map<String, dynamic> json) {
    List<Recipe> result = [];
    List<dynamic> jsonRecipes = json['recipes'];
    for (dynamic jsonRecipe in jsonRecipes) {
      Recipe recipe = Recipe.fromJson(jsonRecipe);
      recipe.addListener(notifyListeners);
      result.add(recipe);
    }
    result.sort((recipeA, recipeB) => recipeA.name.compareTo(recipeB.name));
    _recipes = result;
  }

  Recipe? getRecipeByIndex(int index) => _recipes[index];

  int getRecipeIndex(Recipe recipe) => _recipes.indexOf(recipe);

  void addRecipe(Recipe recipe, {bool notify = true}) {
    if (!_recipes.contains(recipe)) {
      recipe.addListener(notifyListeners);
      _recipes.add(recipe);
      if (notify) {
        notifyListeners();
      }
    }
  }

  void removeRecipe(Recipe recipe, {bool notify = true}) {
    if (_recipes.remove(recipe)) {
      recipe.removeListener(notifyListeners);
      if (notify) {
        notifyListeners();
      }
    }
  }

  @override
  Map<String, dynamic> toJson() => {'recipes': recipes.map((recipe) => recipe.toJson()).toList()};

  @override
  void dispose() {
    for (Recipe recipe in _recipes) {
      recipe.dispose();
    }
    super.dispose();
  }
}
