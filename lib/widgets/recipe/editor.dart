import 'package:cookandchill/model/conditions/condition.dart';
import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/widgets/recipe/dialogs/conditions.dart';
import 'package:cookandchill/widgets/recipe/dialogs/image_picker.dart';
import 'package:cookandchill/widgets/recipe/dialogs/ingredients.dart';
import 'package:cookandchill/widgets/recipe/image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeEditor extends StatelessWidget {
  final Recipe recipe;

  const RecipeEditor({
    Key? key,
    required this.recipe,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RecipeImage(
              recipe: recipe,
              onTap: () async {
                String? asset = await RecipeImagePickerDialog.openDialog(context);
                if (asset != null) {
                  recipe.changeImageAsset(asset);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.restaurant),
                labelText: context.getString('recipe_editor_name'),
              ),
              initialValue: recipe.name,
              onChanged: (value) => recipe.changeName(value, notify: false),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.add),
                labelText: context.getString('recipe_editor_max_meals'),
              ),
              keyboardType: TextInputType.number,
              initialValue: recipe.maxMeals.toString(),
              onChanged: (value) => recipe.changeMaxMeals(int.tryParse(value) ?? 1, notify: false),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.menu_book),
                labelText: context.getString('recipe_editor_recipe'),
                hintText: context.getString('recipe_editor_recipe_hint'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              initialValue: recipe.recipe,
              onChanged: (value) => recipe.changeRecipe(value, notify: false),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.kitchen),
            title: Text(context.getString('recipe_editor_ingredients')),
            subtitle: Text(context.getString('recipe_editor_ingredients_count', {'count': recipe.ingredients.length})),
            minLeadingWidth: 28,
            onTap: () => RecipeIngredientsDialog.openDialog(context, recipe),
          ),
          ListTile(
            leading: const Icon(Icons.check),
            title: Text(context.getString('recipe_editor_conditions')),
            subtitle: Text(context.getString('recipe_editor_conditions_count', {'count': recipe.conditions.length})),
            minLeadingWidth: 28,
            onTap: () => RecipeConditionsDialog.openDialog(context, recipe),
          ),
        ],
      );
}
