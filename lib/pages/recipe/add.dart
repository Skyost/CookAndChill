import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/widgets/recipe/editor.dart';
import 'package:cookandchill/widgets/styled/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeAddPage extends StatelessWidget {
  static const String route = '/recipe/add';

  const RecipeAddPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<Recipe>(
        create: (_) => Recipe(),
        builder: (context, child) => Scaffold(
          appBar: StyledAppBar(
            titleKey: 'page_recipe_add',
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  RecipeModel model = context.read<RecipeModel>();
                  model.addRecipe(context.read<Recipe>());
                  Navigator.pop(context);
                  model.save(notify: false);
                },
              ),
            ],
          ),
          body: RecipeEditor(recipe: context.watch<Recipe>()),
        ),
      );
}
