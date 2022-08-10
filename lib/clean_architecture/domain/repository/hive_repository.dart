abstract class HiveRepositoryInterface {
  Future<void> save({
    required String containerName,
    required String key,
    required dynamic value,
  });

  Future<dynamic> read({required String containerName, required String key});

  Future<bool> contains({required String containerName, required String key});

  Future<void> remove({required String containerName, required String key});
}
