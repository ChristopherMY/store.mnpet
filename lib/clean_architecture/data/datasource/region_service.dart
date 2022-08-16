import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/region_repository.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class RegionService implements RegionRepositoryInterface {
  final _url = Environment.API_DAO;

  // List<District>
  @override
  Future<dynamic> getDistricts({required String provinceId}) async {
    try {
      return await http.get(
        Uri.parse("$_url/api/v1/districts/details/$provinceId"),
        headers: headers,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // List<Province>
  @override
  Future<dynamic> getProvinces({required String departmentId}) async {
    try {
      return await http.get(
        Uri.parse("$_url/api/v1/provinces/details/$departmentId"),
        headers: headers,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // List<Region>
  @override
  Future<dynamic> getRegions() async {
    try {
      return await http.get(
        Uri.parse("$_url/api/v1/regions/departments"),
        headers: headers,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      return e.toString();
    }
  }
}