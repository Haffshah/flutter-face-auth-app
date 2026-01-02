// To parse this JSON data, do
//
//     final stateListResponseModel = stateListResponseModelFromJson(jsonString);

import 'dart:convert';

StateListResponseModel stateListResponseModelFromJson(String str) => StateListResponseModel.fromJson(json.decode(str));

String stateListResponseModelToJson(StateListResponseModel data) => json.encode(data.toJson());

class StateListResponseModel {
  bool? success;
  int? status;
  String? message;
  List<StateData>? data;

  StateListResponseModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory StateListResponseModel.fromJson(Map<String, dynamic> json) => StateListResponseModel(
        success: json['success'],
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? [] : List<StateData>.from(json['data']!.map((x) => StateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'status': status,
        'message': message,
        'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class StateData {
  String? name;
  String? code;
  String? slug;
  String? capital;
  String? type;
  String? tin;
  Source? source;

  StateData({
    this.name,
    this.code,
    this.slug,
    this.capital,
    this.type,
    this.tin,
    this.source,
  });

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
        name: json['name'],
        code: json['code'],
        slug: json['slug'],
        capital: json['capital'],
        type: json['type'],
        tin: json['TIN'],
        source: json['source'] == null ? null : Source.fromJson(json['source']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'slug': slug,
        'capital': capital,
        'type': type,
        'TIN': tin,
        'source': source?.toJson(),
      };
}

class Source {
  String? state;
  String? city;

  Source({
    this.state,
    this.city,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        state: json['state'],
        city: json['city'],
      );

  Map<String, dynamic> toJson() => {
        'state': state,
        'city': city,
      };
}
