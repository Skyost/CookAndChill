import 'package:cookandchill/model/conditions/condition.dart';
import 'package:cookandchill/model/conditions/day_of_week.dart';
import 'package:cookandchill/model/conditions/lunch.dart';
import 'package:cookandchill/model/conditions/season.dart';
import 'package:cookandchill/model/menu_model.dart';
import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/utils/utils.dart';
import 'package:cookandchill/widgets/dialogs/alert_dialog.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecipeConditionsDialog extends StatelessWidget {
  final Recipe recipe;

  const RecipeConditionsDialog({
    Key? key,
    required this.recipe,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => CookAndChillAlertDialog(
    titleKey: 'dialog_conditions_title',
    emptyKey: 'dialog_conditions_empty',
    children: [
      for (Condition condition in recipe.conditions)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _RecipeConditionWidget(
            condition: condition,
            onChanged: recipe.notifyListeners,
            onDelete: () => recipe.removeCondition(condition),
          ),
        ),
    ],
    bottomButton: TextButton.icon(
      onPressed: () async {
        Condition? condition = await _ConditionPickerDialog.openDialog(context);
        if (condition != null) {
          recipe.addCondition(condition);
        }
      },
      icon: const Icon(Icons.add),
      label: Text(context.getString('dialog_conditions_add')),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        overlayColor: MaterialStateProperty.all<Color>(Colors.red[600]!),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder()),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(MaterialLocalizations.of(context).closeButtonLabel.toUpperCase()),
      ),
    ],
  );

  static Future<void> openDialog(BuildContext context, Recipe recipe) => showDialog(
        builder: (context) => ChangeNotifierProvider<Recipe>.value(
            value: recipe,
            builder: (context, child) => RecipeConditionsDialog(recipe: context.watch<Recipe>()),
        ),
        context: context,
      );
}

class _RecipeConditionWidget extends StatelessWidget {
  final Condition condition;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _RecipeConditionWidget({
    Key? key,
    required this.condition,
    required this.onChanged,
    required this.onDelete,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
        ),
        title: _createTitleWidget(context),
        subtitle: _createSubtitleWidget(context),
      );

  Widget? _createTitleWidget(BuildContext context) {
    if (condition is DayOfWeekCondition) {
      return Text(context.getString(condition is NotDayOfWeekCondition ? 'dialog_condition_condition_not_day_of_week' : 'dialog_condition_condition_day_of_week'));
    }
    if (condition is LunchCondition) {
      return Text(context.getString(condition is NotLunchCondition ? 'dialog_condition_condition_not_lunch' : 'dialog_condition_condition_lunch'));
    }
    if (condition is SeasonCondition) {
      return Text(context.getString(condition is NotSeasonCondition ? 'dialog_condition_condition_not_season' : 'dialog_condition_condition_season'));
    }
    return null;
  }

  Widget? _createSubtitleWidget(BuildContext context) {
    if (condition.identifier.startsWith(DayOfWeekCondition.id)) {
      DateTime monday = DateTime.now();
      monday = monday.subtract(Duration(days: monday.day));
      return DropdownButton<int>(
        isExpanded: true,
        value: (condition as DayOfWeekCondition).dayOfWeek,
        onChanged: (value) {
          (condition as DayOfWeekCondition).dayOfWeek = value ?? DateTime.monday;
          onChanged();
        },
        items: [
          for (int day in [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday, DateTime.saturday, DateTime.sunday])
            DropdownMenuItem<int>(
              child: Text(DateFormat('EEEE', EzLocalization.of(context)!.locale.languageCode).format(monday.add(Duration(days: day - 1))).capitalize),
              value: day,
            ),
        ],
      );
    }
    if (condition.identifier.startsWith(SeasonCondition.id)) {
      return DropdownButton<Season>(
        isExpanded: true,
        value: (condition as SeasonCondition).season,
        onChanged: (value) {
          (condition as SeasonCondition).season = value ?? Season.spring;
          onChanged();
        },
        items: [
          for (Season season in Season.values)
            DropdownMenuItem<Season>(
              child: Text(context.getString('dialog_condition_picker_season_${season.name.toLowerCase()}')),
              value: season,
            ),
        ],
      );
    }
    return null;
  }
}

class _ConditionPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CookAndChillAlertDialog(
        titleKey: 'dialog_condition_picker_title',
        children: [
          ListTile(
            title: Text(context.getString('dialog_condition_condition_day_of_week')),
            leading: const Icon(Icons.calendar_today),
            onTap: () => Navigator.pop(context, DayOfWeekCondition(dayOfWeek: DateTime.monday)),
          ),
          ListTile(
            title: Text(context.getString('dialog_condition_condition_not_day_of_week')),
            leading: const Icon(Icons.calendar_today_outlined),
            onTap: () => Navigator.pop(context, NotDayOfWeekCondition(dayOfWeek: DateTime.monday)),
          ),
          ListTile(
            title: Text(context.getString('dialog_condition_condition_lunch')),
            leading: const Icon(Icons.wb_sunny),
            onTap: () => Navigator.pop(context, LunchCondition()),
          ),
          ListTile(
            title: Text(context.getString('dialog_condition_condition_not_lunch')),
            leading: const Icon(Icons.wb_sunny_outlined),
            onTap: () => Navigator.pop(context, NotLunchCondition()),
          ),
          ListTile(
            title: Text(context.getString('dialog_condition_condition_season')),
            leading: const Icon(Icons.wb_cloudy),
            onTap: () => Navigator.pop(context, SeasonCondition(season: Season.spring)),
          ),
          ListTile(
            title: Text(context.getString('dialog_condition_condition_not_season')),
            leading: const Icon(Icons.wb_cloudy_outlined),
            onTap: () => Navigator.pop(context, NotSeasonCondition(season: Season.spring)),
          ),
        ],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase()),
          ),
        ],
      );

  static Future<Condition?> openDialog(BuildContext context) => showDialog<Condition>(
        builder: (context) => _ConditionPickerDialog(),
        context: context,
      );
}
