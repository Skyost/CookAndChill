import 'dart:html' as html;

import 'package:cookandchill/model/storage/storage_interface.dart';

class Storage with StorageInterface {
  html.Storage get localStorage => html.window.localStorage;

  @override
  Future<String> buildPathPrefix() async => '';

  @override
  Future<Iterable<String>> listFiles() async => localStorage.keys;

  @override
  Future<String> readFile(String file) async => localStorage[file]!;

  @override
  Future<void> saveFile(String file, String content) async => localStorage.update(file, (value) => content, ifAbsent: () => content);

  @override
  Future<void> deleteFile(String file) async => localStorage.remove(file);

  @override
  Future<bool> fileExists(String file) async => localStorage.containsKey(file);
}