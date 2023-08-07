import 'dart:core';
import 'package:movies_app/Models/configModel.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class HttpService {
  final Dio dio = Dio();
  final getIt = GetIt.instance;

  late String _apiKey;
  late String _baseUrl;

  HttpService() {
    ConfigModel config = getIt.get<ConfigModel>();
    _apiKey = config.API_Key;
    _baseUrl = config.BASE_API_URL;
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      String url = "$_baseUrl$path"; // Create the url
      Map<String, dynamic> _query = {"api_key": _apiKey, "language": "en-US"};
      // Check if the user ask for specific query
      if (query != null) {
        _query.addAll(query);
      }
      return await dio.get(url, queryParameters: _query);
    } on DioException catch (e) {
      print('Unable to perform get request');
      print("DioError : $e");
      rethrow; // use it to avoid error message for returning null in the function
    }
  }
}
