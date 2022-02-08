import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/widgets/recipe/widget.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final Function(Recipe)? onTap;

  const RecipeList({
    Key? key,
    required this.recipes,
    this.onTap,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => recipes.isEmpty
      ? Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              context.getString('recipe_list_empty'),
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        )
      : ListView(
          padding: const EdgeInsets.all(20).copyWith(top: 0),
          children: [
            for (Recipe recipe in recipes)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RecipeWidget(
                  recipe: recipe,
                  onTap: onTap == null ? null : (() => onTap!(recipe)),
                ),
              )
          ],
        );
}
