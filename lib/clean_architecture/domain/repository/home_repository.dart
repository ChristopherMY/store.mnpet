abstract class HomeRepositoryInterface {
  HomeRepositoryInterface();

  Future<dynamic> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  });

  Future<dynamic> getCategoriesHome();


}