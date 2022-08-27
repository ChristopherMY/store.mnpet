import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class HomeService implements HomeRepositoryInterface {
  final _url = Environment.API_DAO;

  @override
  Future<dynamic> getCategoriesHome() async {
    try {
      return await http.get(
        Uri.parse(
          "$_url/api/v1/categories",
        ),
        headers: headers,
      );
    } on Exception catch (e) {
      return e.toString();
    }
  }

  @override
  Future<dynamic> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  }) async {
    try {
      return await http.get(
        Uri.parse(
          "$_url/api/v1/products/loadmore_scroll?skip=$initialRange&limit=$finalRange",
        ),
        headers: headers,
      );
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
