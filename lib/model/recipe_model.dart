import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/model/storable_model.dart';

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

  int get maxMealCount {
    int result = 0;
    for (Recipe recipe in _recipes) {
      result += recipe.maxMeals;
    }
    return result;
  }

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
