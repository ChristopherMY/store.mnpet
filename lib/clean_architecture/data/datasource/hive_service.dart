import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';

class HiveService implements HiveRepositoryInterface {
  @override
  Future<dynamic> read({
    required String containerName,
    required String key,
  }) async {
    final box1 = await Hive.openBox(containerName);

    if (box1.get(key) == null) return null;
    return json.decode(box1.get(key));
  }

  @override
  Future<void> save({
    required String containerName,
    required String key,
    required dynamic value,
  }) async {
    final box1 = await Hive.openBox(containerName);
    box1.put(key, json.encode(value));
  }

  @override
  Future<bool> contains({
    required String containerName,
    required String key,
  }) async {
    final box1 = await Hive.openBox(containerName);

    return box1.containsKey(key);
  }

  @override
  Future<void> remove({
    required String containerName,
    required String key,
  }) async {
    final box1 = await Hive.openBox(containerName);
    return box1.delete(key);
  }

}
