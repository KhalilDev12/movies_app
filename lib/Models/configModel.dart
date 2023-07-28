import 'dart:convert';

class ConfigModel {
  final String API_Key;
  final String BASE_API_URL;
  final String BASE_IMAGE_API_URL;

  ConfigModel({
    required this.API_Key,
    required this.BASE_API_URL,
    required this.BASE_IMAGE_API_URL,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        API_Key: json["API_Key"],
        BASE_API_URL: json["BASE_API_URL"],
        BASE_IMAGE_API_URL: json["BASE_IMAGE_API_URL"],
      );
}
