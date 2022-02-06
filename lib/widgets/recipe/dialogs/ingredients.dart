import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/widgets/alert_dialog.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeIngredientsDialog extends StatelessWidget {
  final Recipe recipe;

  const RecipeIngredientsDialog({
    Key? key,
    required this.recipe,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => CookAndChillAlertDialog(
        titleKey: 'dialog_ingredients_title',
        emptyKey: 'dialog_ingredients_empty',
        children: [
          for (Ingredient ingredient in recipe.ingredients)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _RecipeIngredientWidget(
                ingredient: ingredient,
                onDelete: () => recipe.removeIngredient(ingredient),
              ),
            ),
        ],
        bottomButton: TextButton.icon(
          onPressed: () => recipe.addIngredient(Ingredient()),
          icon: const Icon(Icons.add),
          label: Text(context.getString('dialog_ingredients_add')),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            overlayColor: MaterialStateProperty.all<Color>(Colors.red[600]!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel.toUpperCase()),
          ),
        ],
      );

  static Future<void> openDialog(BuildContext context, Recipe recipe) => showDialog(
        builder: (context) => ChangeNotifierProvider<Recipe>.value(
          value: recipe,
          builder: (context, child) => RecipeIngredientsDialog(recipe: context.watch<Recipe>()),
        ),
        context: context,
      );
}

class _RecipeIngredientWidget extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback? onDelete;

  const _RecipeIngredientWidget({
    Key? key,
    required this.ingredient,
    this.onDelete,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: context.getString('dialog_ingredients_ingredient_name')),
              initialValue: ingredient.name,
              onChanged: (value) => ingredient.name = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: context.getString('dialog_ingredients_ingredient_quantity')),
              keyboardType: TextInputType.number,
              initialValue: ingredient.count.toString(),
              onChanged: (value) => ingredient.count = int.tryParse(value) ?? 1,
            ),
          ],
        ),
      );
}
