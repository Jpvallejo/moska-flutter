import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Custom Implementation of CacheManager
// by extending the BaseCacheManager abstract class
class MoskaCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static MoskaCacheManager _instance;

  factory MoskaCacheManager() {
    if (_instance == null) {
      _instance = new MoskaCacheManager._();
    }
    return _instance;
  }

  MoskaCacheManager._() : super(key,
      maxAgeCacheObject: Duration(days: 1),
      maxNrOfCacheObjects: 20);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}