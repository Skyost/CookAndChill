import 'package:cookandchill/model/menu_model.dart';
import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/model/settings_model.dart';
import 'package:cookandchill/pages/home.dart';
import 'package:cookandchill/pages/menu/display.dart';
import 'package:cookandchill/pages/menu/intro.dart';
import 'package:cookandchill/pages/recipe/add.dart';
import 'package:cookandchill/pages/recipe/edit.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: 'Cook&Chill',
    primaryColor: Colors.red.value,
  ));
  runApp(const CookAndChillApp());
}

class CookAndChillApp extends StatelessWidget {
  const CookAndChillApp({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    EzLocalizationDelegate ezLocalization = const EzLocalizationDelegate(supportedLocales: [Locale('en'), Locale('fr')]);
    TextTheme textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeModel>(create: (_) {
          RecipeModel model = RecipeModel();
          model.initialize();
          return model;
        }),
        ChangeNotifierProvider<MenuModel>(create: (_) => MenuModel()),
        ChangeNotifierProvider<SettingsModel>(create: (_) {
          SettingsModel model = SettingsModel();
          model.initialize();
          return model;
        }),
      ],
      child: MaterialApp(
        title: 'Cook&Chill',
        localizationsDelegates: ezLocalization.localizationDelegates,
        supportedLocales: ezLocalization.supportedLocales,
        localeResolutionCallback: ezLocalization.localeResolutionCallback,
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: TextTheme(
            headline1: GoogleFonts.raleway(textStyle: textTheme.headline1),
            headline2: GoogleFonts.raleway(textStyle: textTheme.headline2),
            headline3: GoogleFonts.raleway(textStyle: textTheme.headline3),
            headline4: GoogleFonts.raleway(textStyle: textTheme.headline4),
            headline5: GoogleFonts.raleway(textStyle: textTheme.headline5),
            headline6: GoogleFonts.raleway(textStyle: textTheme.headline6),
            subtitle1: GoogleFonts.raleway(textStyle: textTheme.subtitle1),
            subtitle2: GoogleFonts.raleway(textStyle: textTheme.subtitle2),
            bodyText1: GoogleFonts.bitter(textStyle: textTheme.bodyText1),
            bodyText2: GoogleFonts.bitter(textStyle: textTheme.bodyText2),
            caption: GoogleFonts.bitter(textStyle: textTheme.caption),
            button: GoogleFonts.bitter(textStyle: textTheme.button),
            overline: GoogleFonts.bitter(textStyle: textTheme.overline),
          ),
          buttonTheme: const ButtonThemeData(
            shape: RoundedRectangleBorder(),
          ),
        ),
        initialRoute: HomePage.route,
        routes: {
          HomePage.route: (context) => const HomePage(),
          RecipeAddPage.route: (context) => RecipeAddPage(),
          RecipeEditPage.route: (context) {
            Recipe? recipe = ModalRoute.of(context)?.settings.arguments as Recipe?;
            if (recipe == null) {
              WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.pop(context));
              return const HomePage();
            }
            return RecipeEditPage(recipe: recipe);
          },
          MenuIntroPage.route: (context) => const MenuIntroPage(),
          MenuDisplayPage.route: (context) => const MenuDisplayPage(),
        },
      ),
    );
  }
}
