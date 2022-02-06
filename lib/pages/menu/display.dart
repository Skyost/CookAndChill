import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cookandchill/model/menu_model.dart';
import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/utils/utils.dart';
import 'package:cookandchill/widgets/alert_dialog.dart';
import 'package:cookandchill/widgets/recipe/widget.dart';
import 'package:cookandchill/widgets/styled/app_bar.dart';
import 'package:cookandchill/widgets/styled/background.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MenuDisplayPage extends StatelessWidget {
  static const String route = '/menu/display';

  const MenuDisplayPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    MenuModel model = context.watch<MenuModel>();
    return model.isMenuCrafted ? _MenuDisplayScaffold(menuModel: model) : const _MenuLoadingScaffold();
  }
}

class _MenuDisplayScaffold extends StatelessWidget {
  final MenuModel menuModel;

  const _MenuDisplayScaffold({
    Key? key,
    required this.menuModel,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: StyledAppBar(
          titleKey: 'page_menu_display_title',
          actions: [
            IconButton(
              onPressed: () => _MenuIngredients.openDialog(context, menuModel.ingredients),
              icon: const Icon(Icons.set_meal),
            ),
          ],
        ),
        body: ListView(
          children: [
            for (MealDateTime date in menuModel.dates)
              StickyHeader(
                header: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          date.toDateTime().formatDayMonth(context),
                          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                        ),
                      ),
                      Text(
                        context.getString(date.lunch ? 'page_menu_display_lunch' : 'page_menu_display_diner'),
                        style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(20),
                  child: RecipeWidget(
                    recipe: menuModel.getRecipeAt(date)!,
                    onTap: () async {
                      Recipe? recipe = await _RecipePicker.openDialog(context, date, menuModel.getRecipeAt(date));
                      if (recipe != null) {
                        menuModel.changeRecipeAt(date, recipe);
                      }
                    },
                    subtitleText: date.toDateTime().formatDayMonth(context) + ' • ' + context.getString(date.lunch ? 'page_menu_display_lunch' : 'page_menu_display_diner'),
                  ),
                ),
              ),
          ],
        ),
      );
}

class _MenuLoadingScaffold extends StatelessWidget {
  const _MenuLoadingScaffold({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.red,
          body: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                const Positioned.fill(child: StyledBackground()),
                Positioned(
                  top: 20,
                  right: 20,
                  left: 20,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TyperAnimatedText(
                        context.getString('page_menu_display_loading'),
                        textAlign: TextAlign.center,
                        textStyle: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: ConstrainedBox(
                    constraints: constraints,
                    child: Lottie.asset('assets/lottie/loading.json'),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false),
      );
}

class _MenuIngredients extends StatelessWidget {
  final List<Ingredient> ingredients;

  const _MenuIngredients({
    Key? key,
    required this.ingredients,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => CookAndChillAlertDialog(
        titleKey: 'page_menu_display_ingredients_title',
        emptyKey: 'page_menu_display_ingredients_empty',
        children: [
          for (Ingredient ingredient in ingredients)
            ListTile(
              title: Text(ingredient.name),
              trailing: Text('x${ingredient.count}'),
            ),
        ],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel.toUpperCase()),
          ),
        ],
      );

  static Future<void> openDialog(BuildContext context, List<Ingredient> ingredients) => showDialog(
        builder: (context) => _MenuIngredients(ingredients: ingredients),
        context: context,
      );
}

class _RecipePicker extends StatelessWidget {
  final MealDateTime date;
  final Recipe? currentRecipe;

  const _RecipePicker({
    Key? key,
    required this.date,
    this.currentRecipe,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    RecipeModel model = context.watch<RecipeModel>();
    return CookAndChillAlertDialog(
      titleKey: 'page_menu_display_replace_recipe_title',
      emptyKey: 'page_menu_display_replace_recipe_empty',
      children: [
        for (Recipe recipe in model.recipes)
          if (recipe != currentRecipe)
            ListTile(
              title: Text(recipe.name, style: recipe.areConditionsMet(date) ? null : const TextStyle(color: Colors.red)),
              trailing: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => Navigator.pop(context, recipe),
              ),
            ),
      ],
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase()),
        ),
      ],
    );
  }

  static Future<Recipe?> openDialog(BuildContext context, MealDateTime date, Recipe? currentRecipe) => showDialog<Recipe>(
        builder: (context) => _RecipePicker(date: date, currentRecipe: currentRecipe),
        context: context,
      );
}
