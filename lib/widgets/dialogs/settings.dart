import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/model/settings_model.dart';
import 'package:cookandchill/widgets/dialogs/alert_dialog.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    SettingsModel model = context.watch<SettingsModel>();
    return CookAndChillAlertDialog(
      titleKey: 'dialog_settings_title',
      children: [
        ListTile(
          title: Text(context.getString('dialog_settings_theme')),
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
                  child: Text(context.getString('dialog_settings_theme_${style.name.toLowerCase()}')),
                  value: style,
                ),
            ],
          ),
        ),
      ],
      actions: [
        if (!kIsWeb)
          TextButton(
            onPressed: () async {
              bool? confirmation = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  content: Text(context.getString('dialog_settings_confirmation')),
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

              String? inputFile;
              if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS) {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                  lockParentWindow: true,
                );
                inputFile = result?.files.single.path;
              } else {
                inputFile = await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
                if (inputFile != null) {
                  inputFile += 'recipes.json';
                }
              }

              if (inputFile != null) {
                try {
                  RecipeModel model = context.read<RecipeModel>();
                  await model.initialize(file: inputFile);
                  await model.save();
                } catch (ex) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(ex.toString()),
                    backgroundColor: Colors.red[900],
                  ));
                }
              }
            },
            child: Text(context.getString('dialog_settings_import').toUpperCase()),
          ),
        if (!kIsWeb)
          TextButton(
            onPressed: () async {
              String? outputFile;
              if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS) {
                outputFile = await (FilePicker.platform.saveFile(
                  fileName: 'recipes',
                  allowedExtensions: ['json'],
                  type: FileType.custom,
                  lockParentWindow: true,
                ));
              } else {
                outputFile = await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
                if (outputFile != null) {
                  outputFile += 'recipes.json';
                }
              }
              if (outputFile != null) {
                if (!outputFile.endsWith('.json')) {
                  outputFile += '.json';
                }
                try {
                  context.read<RecipeModel>().save(file: outputFile);
                } catch (ex) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(ex.toString()),
                    backgroundColor: Colors.red[900],
                  ));
                }
              }
              Navigator.pop(context);
            },
            child: Text(context.getString('dialog_settings_export').toUpperCase()),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel.toUpperCase()),
        ),
      ],
    );
  }

  static Future<void> openDialog(BuildContext context) => showDialog(
        builder: (context) => const SettingsDialog(),
        context: context,
      );
}
