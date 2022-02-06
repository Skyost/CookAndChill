import 'package:cookandchill/model/storage/storage_interface.dart';

class Storage with StorageInterface {
  @override
  Future<String> buildPathPrefix() async => '';

  @override
  Future<Iterable<String>> listFiles() async => [];

  @override
  Future<String> readFile(String file) async => '[]';

  @override
  Future<void> saveFile(String file, String content) async {}

  @override
  Future<void> deleteFile(String file) async {}

  @override
  Future<bool> fileExists(String file) async => true;
}
