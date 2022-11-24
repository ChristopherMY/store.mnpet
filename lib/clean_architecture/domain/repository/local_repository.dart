
import '../../helper/http_response.dart';
abstract class LocalRepositoryInterface{
  const LocalRepositoryInterface();

  Future<String?> getToken();

  Future<String?> saveToken(String token);

  Future<void> clearAllData();

  // List<Region>
  Future<HttpResponse> getRegions();

  // List<Province>
  Future<HttpResponse> getProvinces({required String departmentId});

  // List<District>
  Future<HttpResponse> getDistricts({required String provinceId});

  // List<Keyword>
  Future<HttpResponse> getKeywords();
}