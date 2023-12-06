import 'dart:convert';

import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/location_/region.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class LocationService {
  final NetworkService _networkService = getIt<NetworkService>();

  Future<List<Location>> getAllProvince() async {
    try {
      final response = await _networkService.getRequest(PROVINCES_URL,
          baseUrl: LOCATION_API_BASE_URL);
      List<dynamic> data = jsonDecode(response);
      List<Location> province =
          data.map((json) => Location.fromJson(json)).toList();
      return province;
    } on DioException catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Location>> getAllMunicipalitiesByProvince(String code) async {
    final String url = '$PROVINCES_URL/$code$MUNICIPALITY_URL';
    print(url);
    try {
      final response =
          await _networkService.getRequest(url, baseUrl: LOCATION_API_BASE_URL);
      List<dynamic> data = jsonDecode(response);
      List<Location> municipality =
          data.map((json) => Location.fromJson(json)).toList();
      return municipality;
    } on DioException catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Location>> getAllCityByProvince(String code) async {
    final String url = '$PROVINCES_URL/$code$CITY_URL';
    print(url);
    try {
      final response =
          await _networkService.getRequest(url, baseUrl: LOCATION_API_BASE_URL);
      List<dynamic> data = jsonDecode(response);
      List<Location> city =
          data.map((json) => Location.fromJson(json)).toList();
      return city;
    } on DioException catch (e) {
      print(e.toString());
      return [];
    }
  }

//NONE
  Future<List<Location>> getAllBarangayByCity(String code) async {
    final String url = '$CityAndMunicipality_URL/$code$BARANGAY_URL';
    print(url);
    try {
      final response =
          await _networkService.getRequest(url, baseUrl: LOCATION_API_BASE_URL);
      List<dynamic> data = jsonDecode(response);
      List<Location> cityBarangay =
          data.map((json) => Location.fromJson(json)).toList();
      return cityBarangay;
    } on DioException catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Location>> getAllBarangayByMunicipalityOrCity(String code) async {
    final String url = '$CityAndMunicipality_URL/$code$BARANGAY_URL';
    print(url);
    try {
      final response =
          await _networkService.getRequest(url, baseUrl: LOCATION_API_BASE_URL);
      List<dynamic> data = jsonDecode(response);
      List<Location> barangay =
          data.map((json) => Location.fromJson(json)).toList();
      return barangay;
    } on DioException catch (e) {
      print(e.toString());
      return [];
    }
  }

//TAMAN
}


/**
 * 
 * [Location(name,code), Location]
 */