import 'package:cookandchill/model/storable_model.dart';

class SettingsModel extends StorableModel {
  AppStyle _style = AppStyle.material;

  AppStyle get style => _style;

  void changeStyle(AppStyle style, {bool notify = true}) {
    _style = style;
    if (notify) {
      notifyListeners();
    }
  }

  @override
  String get file => '.cookandchill';

  @override
  void loadJson(Map<String, dynamic> json) {
    _style = AppStyle.values.firstWhere((style) => style.name == json['style'], orElse: () => AppStyle.material);
  }

  @override
  Map<String, dynamic> toJson() => {'style': _style.name};
}

enum AppStyle {
  material,
  italian,
}
