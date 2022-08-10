abstract class RegionRepositoryInterface {
  // List<Region>
  Future<dynamic> getRegions();

  // List<Province>
  Future<dynamic> getProvinces({required String departmentId});

  // List<District>
  Future<dynamic> getDistricts({required String provinceId});
}
