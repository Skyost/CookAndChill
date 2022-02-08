import 'package:cookandchill/widgets/dialogs/alert_dialog.dart';
import 'package:cookandchill/widgets/recipe/image.dart';
import 'package:flutter/material.dart';

class RecipeImagePickerDialog extends StatelessWidget {
  static const List<String> _assets = [
    'affogato',
    'berry-pie',
    'boiled-egg',
    'bread',
    'canned-food',
    'coconut',
    'cookie',
    'cotton-candy',
    'crab',
    'dumpling',
    'fish',
    'french-fries',
    'fried-rice',
    'frozen-yogurt',
    'honey-jar',
    'hot',
    'korean',
    'lasagna',
    'mashed-potato',
    'muffins',
    'nachos',
    'noodles',
    'omelette',
    'opera',
    'pancake',
    'pasta',
    'pizza-slice',
    'popcorn',
    'porridge',
    'rice',
    'rice-2',
    'salad',
    'samosa',
    'sandwich',
    'satay',
    'sausage',
    'shaved-ice',
    'shrimp',
    'soft',
    'soup',
    'steak',
    'strawberry-jam',
    'sushi',
    'taco',
    'taiyaki',
    'takoyaki',
    'udon',
    'waffle',
    'watermelon',
    'wine'
  ];

  const RecipeImagePickerDialog({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => CookAndChillAlertDialog.oneChild(
        titleKey: 'dialog_image_picker_title',
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: [
            for (String asset in _assets)
              RecipeImage.fromAsset(
                asset: 'assets/recipes/$asset.png',
                onTap: () => Navigator.pop(context, asset),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase()),
          ),
        ],
      );

  static Future<String?> openDialog(BuildContext context) => showDialog<String>(
        builder: (context) => const RecipeImagePickerDialog(),
        context: context,
      );
}
