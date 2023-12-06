import 'dart:convert';
import 'dart:io';
import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:dio/dio.dart';

class UserService {
  final NetworkService _networkService = NetworkService();

  Future editProfile(Map<String, dynamic> data) async {
    try {
      await _networkService.putRequest(USERS_URL, body: data);
      return true;
    } on DioException catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future<dynamic> getUserDetails() async {
    try {
      final result = await _networkService.getRequest(USERS_URL);
      return result;
    } on DioException catch (e) {
      throw false;
    }
  }

  Future<dynamic> uploadImage(Map<File, dynamic> data) async {
    try {
      final result = await _networkService.postRequest(USERS_URL, body: data);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<dynamic> saveImageProfile(
      CroppedFile? croppedFile, Map<String, dynamic> data) async {
    // String url = PROFILE_UR;
    // try{

    // }
  }
}
