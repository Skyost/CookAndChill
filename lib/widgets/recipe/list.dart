import 'package:async/async.dart';
import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/widgets/recipe/widget.dart';
import 'package:diacritic/diacritic.dart' as diacritic;
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

class RecipeList extends StatefulWidget {
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
  State<StatefulWidget> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late List<Recipe> recipes;
  CancelableOperation<void>? filterOperation;

  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    recipes = widget.recipes;
  }

  @override
  void didUpdateWidget(covariant RecipeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recipes != widget.recipes) {
      recipes = widget.recipes;
      updateRecipes();
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (scrollController.hasClients && scrollController.position.pixels == 0 && scrollController.position.maxScrollExtent >= 70) {
          scrollController.jumpTo(70);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.recipes.isEmpty
      ? Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              context.getString('recipe_list_empty'),
              style: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
        )
      : ListView(
          padding: const EdgeInsets.all(20),
          controller: scrollController,
          children: [
            TextField(
              controller: textEditingController,
              textInputAction: TextInputAction.search,
              onChanged: (searchTerms) {
                filterOperation?.cancel();
                filterOperation = CancelableOperation.fromFuture(Future.delayed(const Duration(milliseconds: 200))).then((_) => updateRecipes());
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.06),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.zero,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                labelText: context.getString('recipe_list_search'),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
            if (recipes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  context.getString('recipe_list_not_found'),
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            for (Recipe recipe in recipes)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RecipeWidget(
                  recipe: recipe,
                  onTap: widget.onTap == null ? null : (() => widget.onTap!(recipe)),
                ),
              )
          ],
        );

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void updateRecipes() {
    if (!mounted) {
      return;
    }

    if (textEditingController.text.trim().isEmpty) {
      setState(() => recipes = widget.recipes);
      return;
    }
    String normalizedSearchTerms = normalizeString(textEditingController.text);
    setState(() => recipes = widget.recipes.where((recipe) => normalizeString(recipe.name).contains(normalizedSearchTerms)).toList());
  }

  String normalizeString(String string) => diacritic.removeDiacritics(unorm.nfc(string).toLowerCase());
}
