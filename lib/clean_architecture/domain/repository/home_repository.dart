
import '../../helper/http_response.dart';

abstract class HomeRepositoryInterface {
  HomeRepositoryInterface();

  Future<HttpResponse> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  });

  Future<HttpResponse> getCategoriesHome();

  Future<HttpResponse> getBannersHome();
}