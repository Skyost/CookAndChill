abstract class StorageInterface {
  Future<String> buildPathPrefix();

  Future<Iterable<String>> listFiles();

  Future<String> readFile(String file);

  Future<void> saveFile(String file, String content);

  Future<void> deleteFile(String file);

  Future<bool> fileExists(String file);
}