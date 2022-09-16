

abstract class LocalRepositoryInterface{
  const LocalRepositoryInterface();

  Future<String?> getToken();

  Future<String?> saveToken(String token);

  Future<void> clearAllData();

  // List<Region>
  Future<dynamic> getRegions();

  // List<Province>
  Future<dynamic> getProvinces({required String departmentId});

  // List<District>
  Future<dynamic> getDistricts({required String provinceId});

  // List<Keyword>
  Future<dynamic> getKeywords();
}