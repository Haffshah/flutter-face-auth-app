// To parse this JSON data, do
//
//     final cityListResponseModel = cityListResponseModelFromJson(jsonString);

import 'dart:convert';

CityListResponseModel cityListResponseModelFromJson(String str) => CityListResponseModel.fromJson(json.decode(str));

String cityListResponseModelToJson(CityListResponseModel data) => json.encode(data.toJson());

class CityListResponseModel {
  bool? success;
  int? status;
  String? message;
  List<String>? data;

  CityListResponseModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory CityListResponseModel.fromJson(Map<String, dynamic> json) => CityListResponseModel(
        success: json['success'],
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? [] : List<String>.from(json['data']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'status': status,
        'message': message,
        'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
