import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/widgets/recipe/image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final String? subtitleText;

  const RecipeWidget({
    Key? key,
    required this.recipe,
    this.onTap,
    this.subtitleText,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: RecipeImage.size / 2),
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20).copyWith(top: RecipeImage.size / 2 + 10),
                width: double.infinity,
                color: Colors.black.withOpacity(0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        recipe.name,
                        style: Theme.of(context).textTheme.headline4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      subtitleText ?? context.getString('recipe_list_subtitle', {'maxMeals': recipe.maxMeals, 'ingredientCount': recipe.ingredients.length}),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: RecipeImage(
              recipe: recipe,
              onTap: onTap,
            ),
            top: 0,
            right: 0,
            left: 0,
            height: RecipeImage.size,
          ),
        ],
      );
}
