import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/pages/menu/intro.dart';
import 'package:cookandchill/pages/recipe/add.dart';
import 'package:cookandchill/pages/recipe/edit.dart';
import 'package:cookandchill/widgets/dialogs/settings.dart';
import 'package:cookandchill/widgets/recipe/list.dart';
import 'package:cookandchill/widgets/styled/app_bar.dart';
import 'package:cookandchill/widgets/styled/floating_action_button.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';

  const HomePage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    RecipeModel model = context.watch<RecipeModel>();
    return Scaffold(
      appBar: StyledAppBar(
        titleKey: 'page_home_title',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, RecipeAddPage.route),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => SettingsDialog.openDialog(context),
          ),
        ],
      ),
      body: RecipeList(
        recipes: model.recipes,
        onTap: (recipe) => Navigator.pushNamed(context, RecipeEditPage.route, arguments: recipe),
      ),
      floatingActionButton: StyledActionButton(
        child: const Icon(Icons.restaurant_menu_outlined),
        onPressed: () {
          if (model.maxMealCount == 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(context.getString('page_home_not_enough_meals')),
              backgroundColor: Colors.red[900],
            ));
            return;
          }
          Navigator.pushNamed(context, MenuIntroPage.route);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
