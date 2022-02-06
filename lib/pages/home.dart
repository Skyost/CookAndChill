import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/model/settings_model.dart';
import 'package:cookandchill/pages/recipe/add.dart';
import 'package:cookandchill/pages/menu/intro.dart';
import 'package:cookandchill/pages/recipe/edit.dart';
import 'package:cookandchill/widgets/alert_dialog.dart';
import 'package:cookandchill/widgets/recipe/list.dart';
import 'package:cookandchill/widgets/styled/app_bar.dart';
import 'package:cookandchill/widgets/styled/background.dart';
import 'package:cookandchill/widgets/styled/floating_action_button.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:file_picker/file_picker.dart';
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
            onPressed: () => _SettingsDialog.openDialog(context),
          ),
        ],
      ),
      body: RecipeList(
        recipes: model.recipes,
        onTap: (recipe) => Navigator.pushNamed(context, RecipeEditPage.route, arguments: recipe),
      ),
      floatingActionButton: StyledActionButton(
        child: const Icon(Icons.restaurant_menu_outlined),
        onPressed: () => Navigator.pushNamed(context, MenuIntroPage.route),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsModel model = context.watch<SettingsModel>();
    return CookAndChillAlertDialog(
      titleKey: 'page_home_settings',
      children: [
        ListTile(
          title: Text(context.getString('page_home_settings_theme')),
          subtitle: DropdownButton<AppStyle>(
            isExpanded: true,
            value: model.style,
            onChanged: (value) {
              model.changeStyle(value ?? AppStyle.material);
              model.save(notify: false);
            },
            items: [
              for (AppStyle style in AppStyle.values)
                DropdownMenuItem<AppStyle>(
                  child: Text(context.getString('page_home_settings_theme_${style.name.toLowerCase()}')),
                  value: style,
                ),
            ],
          ),
        ),
      ],
      actions: [
        TextButton(
          onPressed: () async {
            bool? confirmation = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                content: Text(context.getString('page_home_settings_theme_confirmation')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase()),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(MaterialLocalizations.of(context).continueButtonLabel.toUpperCase()),
                  ),
                ],
              ),
            );

            if (confirmation != true) {
              return;
            }

            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['json'],
              lockParentWindow: true,
            );

            if (result != null) {
              try {
                RecipeModel model = context.read<RecipeModel>();
                await model.initialize(file: result.files.single.path);
                await model.save();
              } catch (ex) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ex.toString()),
                  backgroundColor: Colors.red,
                ));
              }
            }
          },
          child: Text(context.getString('page_home_settings_theme_import').toUpperCase()),
        ),
        TextButton(
          onPressed: () async {
            String? outputFile = await FilePicker.platform.saveFile(
              fileName: 'recipes',
              allowedExtensions: ['json'],
              type: FileType.custom,
              lockParentWindow: true,
            );
            if (outputFile != null) {
              if (!outputFile.endsWith('.json')) {
                outputFile += '.json';
              }
              try {
                context.read<RecipeModel>().save(file: outputFile);
              } catch (ex) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ex.toString()),
                  backgroundColor: Colors.red,
                ));
              }
            }
            Navigator.pop(context);
          },
          child: Text(context.getString('page_home_settings_theme_export').toUpperCase()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel.toUpperCase()),
        ),
      ],
    );
  }

  static Future<void> openDialog(BuildContext context) => showDialog(
        builder: (context) => _SettingsDialog(),
        context: context,
      );
}
