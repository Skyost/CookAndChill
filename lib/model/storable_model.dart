import 'dart:convert';

import 'package:cookandchill/model/storage/storage.dart';
import 'package:flutter/material.dart';

abstract class StorableModel with ChangeNotifier {
  @protected
  String get file;

  Future<void> initialize({String? file, bool notify = true}) async {
    if (!(await storage.fileExists(file ?? this.file))) {
      return;
    }

    loadJson(json.decode(await storage.readFile(file ?? this.file)));
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> save({String? file, bool notify = true}) async {
    await storage.saveFile(file ?? this.file, json.encode(toJson()));
    if (notify) {
      notifyListeners();
    }
  }

  @protected
  void loadJson(Map<String, dynamic> json);

  @protected
  Map<String, dynamic> toJson();
}
