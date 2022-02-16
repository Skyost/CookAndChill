import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/widgets/recipe/editor.dart';
import 'package:cookandchill/widgets/styled/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeEditPage extends StatelessWidget {
  static const String route = '/recipe/edit';

  final Recipe recipe;

  const RecipeEditPage({
    Key? key,
    required this.recipe,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<Recipe>.value(
        value: recipe,
        builder: (context, child) => WillPopScope(
          onWillPop: () async {
            context.read<RecipeModel>().save();
            return true;
          },
          child: Scaffold(
            appBar: StyledAppBar(
              titleKey: 'page_recipe_edit',
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    RecipeModel model = context.read<RecipeModel>();
                    model.removeRecipe(context.read<Recipe>());
                    Navigator.pop(context);
                    model.save(notify: false);
                  },
                ),
              ],
            ),
            body: RecipeEditor(recipe: context.watch<Recipe>()),
          ),
        ),
      );
}
