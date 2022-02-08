import 'package:cookandchill/model/recipe.dart';
import 'package:cookandchill/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class RecipeImage extends StatefulWidget {
  static const double size = 100;

  final Image image;
  final VoidCallback? onTap;

  RecipeImage({
    Key? key,
    required Recipe recipe,
    VoidCallback? onTap,
  }) : this.fromAsset(
          key: key,
          asset: recipe.imageAsset,
          onTap: onTap,
        );

  RecipeImage.fromAsset({
    Key? key,
    required String asset,
    this.onTap,
  })  : image = Image.asset(asset),
        super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  Color backgroundColor = Colors.transparent;
  Color splashColor = Colors.black26;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => refreshBackground());
  }

  @override
  void didUpdateWidget(covariant RecipeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      refreshBackground();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Padding(
      padding: const EdgeInsets.all(15),
      child: widget.image,
    );

    if (widget.onTap != null) {
      image = Material(
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: widget.onTap,
          child: image,
          splashColor: splashColor,
        ),
        color: Colors.transparent,
      );
    }

    return Container(
      height: RecipeImage.size,
      width: RecipeImage.size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: image,
    );
  }

  Future<void> refreshBackground () async {
    PaletteGenerator palette = await PaletteGenerator.fromImageProvider(widget.image.image);
    if (mounted) {
      setState(() {
        backgroundColor = palette.lightVibrantColor?.color.lighten(0.2) ?? Colors.transparent;
        splashColor = palette.darkMutedColor?.color.withOpacity(0.2) ?? Colors.black26;
      });
    }
  }
}
