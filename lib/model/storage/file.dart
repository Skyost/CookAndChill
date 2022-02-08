import 'dart:io';

import 'package:cookandchill/model/storage/storage_interface.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Storage with StorageInterface {
  String? _pathPrefix;

  @override
  Future<String> buildPathPrefix() async {
    _pathPrefix ??= '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}';
    return _pathPrefix!;
  }

  @override
  Future<List<String>> listFiles() async {
    List<String> result = [];
    List<FileSystemEntity> files = (await getApplicationDocumentsDirectory()).listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        result.add(file.path);
      }
    }
    return result;
  }

  @override
  Future<String> readFile(String file) async => await (await _getFile(file)).readAsString();

  @override
  Future<void> saveFile(String file, String content) async => await (await _getFile(file)).writeAsString(content);

  @override
  Future<void> deleteFile(String file) async => await (await _getFile(file)).delete();

  @override
  Future<bool> fileExists(String file) async => await (await _getFile(file)).exists();

  Future<File> _getFile(String file) async => path.isAbsolute(file) ? File(file) : File((await buildPathPrefix()) + file);
}
