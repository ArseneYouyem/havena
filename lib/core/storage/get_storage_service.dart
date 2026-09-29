import 'package:get_storage/get_storage.dart';

class GetStorageService {
  GetStorageService();

  final GetStorage _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }
}
