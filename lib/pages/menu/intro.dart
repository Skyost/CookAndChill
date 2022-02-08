import 'package:cookandchill/model/menu_model.dart';
import 'package:cookandchill/model/recipe_model.dart';
import 'package:cookandchill/pages/menu/display.dart';
import 'package:cookandchill/widgets/styled/app_bar.dart';
import 'package:cookandchill/widgets/styled/background.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuIntroPage extends StatelessWidget {
  static const String route = '/menu/intro';

  const MenuIntroPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Theme(
      data: ThemeData(
        textTheme: textTheme.copyWith(
          headline4: GoogleFonts.raleway(textStyle: textTheme.headline4, color: Colors.white),
          headline5: GoogleFonts.raleway(textStyle: textTheme.headline5, color: Colors.white),
          bodyText2: GoogleFonts.bitter(textStyle: textTheme.bodyText2, color: Colors.white),
          button: GoogleFonts.bitter(textStyle: textTheme.button, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.red,
        extendBodyBehindAppBar: true,
        appBar: const StyledAppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            const Positioned.fill(child: StyledBackground()),
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(child: _MenuIntroPageBody()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuIntroPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MenuModel menuModel = context.watch<MenuModel>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            context.getString('page_menu_intro_title'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            context.getString('page_menu_intro_message'),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            spacing: 20,
            children: [
              IconButton(
                onPressed: () => menuModel.changeMealCount(menuModel.mealCount - 1, context.read<RecipeModel>()),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                menuModel.mealCount.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              IconButton(
                onPressed: () => menuModel.changeMealCount(menuModel.mealCount + 1, context.read<RecipeModel>()),
                icon: const Icon(Icons.add_circle_outline),
              )
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            menuModel.resetMenu();
            Navigator.pushNamed(context, MenuDisplayPage.route);
            await Future.delayed(const Duration(seconds: 1));
            menuModel.craftMenu(context.read<RecipeModel>());
          },
          icon: const Icon(Icons.chevron_right),
          label: Text(context.getString('page_menu_intro_button')),
          style: ButtonStyle(textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.headline5)),
        )
      ],
    );
  }
}
