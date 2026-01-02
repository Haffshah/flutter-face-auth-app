// To parse this JSON data, do
//
//     final signInResponseModel = signInResponseModelFromJson(jsonString);

import 'dart:convert';

SignInResponseModel signInResponseModelFromJson(String str) => SignInResponseModel.fromJson(json.decode(str));

String signInResponseModelToJson(SignInResponseModel data) => json.encode(data.toJson());

class SignInResponseModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  SignInResponseModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) => SignInResponseModel(
        success: json['success'],
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  int? id;
  String? fullName;
  String? designation;
  String? companyName;
  String? companyType;
  String? email;
  String? emailVerifiedAt;
  String? phoneCode;
  String? phoneNumber;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  String? latitude;
  String? longitude;
  String? passwordOtp;
  String? passwordOtpCreatedAt;
  String? deviceType;
  String? deviceToken;
  int? isActive;
  int? isSuparAdmin;
  int? isOrganization;
  int? isMember;
  int? avatarId;
  String? deleteAccountRequestAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;
  Avatar? avatar;

  Data({
    this.id,
    this.fullName,
    this.designation,
    this.companyName,
    this.companyType,
    this.email,
    this.emailVerifiedAt,
    this.phoneCode,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.passwordOtp,
    this.passwordOtpCreatedAt,
    this.deviceType,
    this.deviceToken,
    this.isActive,
    this.isSuparAdmin,
    this.isOrganization,
    this.isMember,
    this.avatarId,
    this.deleteAccountRequestAt,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.avatar,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        fullName: json['full_name'],
        designation: json['designation'],
        companyName: json['company_name'],
        companyType: json['company_type'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'],
        phoneCode: json['phone_code'],
        phoneNumber: json['phone_number'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        zipCode: json['zip_code'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        passwordOtp: json['password_otp'],
        passwordOtpCreatedAt: json['password_otp_created_at'],
        deviceType: json['device_type'],
        deviceToken: json['device_token'],
        isActive: json['is_active'],
        isSuparAdmin: json['is_supar_admin'],
        isOrganization: json['is_organization'],
        isMember: json['is_member'],
        avatarId: json['avatar_id'],
        deleteAccountRequestAt: json['delete_account_request_at'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        token: json['token'],
        avatar: json['avatar'] == null ? null : Avatar.fromJson(json['avatar']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'designation': designation,
        'company_name': companyName,
        'company_type': companyType,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'phone_code': phoneCode,
        'phone_number': phoneNumber,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'zip_code': zipCode,
        'latitude': latitude,
        'longitude': longitude,
        'password_otp': passwordOtp,
        'password_otp_created_at': passwordOtpCreatedAt,
        'device_type': deviceType,
        'device_token': deviceToken,
        'is_active': isActive,
        'is_supar_admin': isSuparAdmin,
        'is_organization': isOrganization,
        'is_member': isMember,
        'avatar_id': avatarId,
        'delete_account_request_at': deleteAccountRequestAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'token': token,
        'avatar': avatar?.toJson(),
      };
}

class Avatar {
  int? id;
  String? originalName;
  String? name;
  String? path;
  String? size;
  String? fullPath;
  String? mimeType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Avatar({
    this.id,
    this.originalName,
    this.name,
    this.path,
    this.size,
    this.fullPath,
    this.mimeType,
    this.createdAt,
    this.updatedAt,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json['id'],
        originalName: json['original_name'],
        name: json['name'],
        path: json['path'],
        size: json['size'],
        fullPath: json['full_path'],
        mimeType: json['mime_type'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'original_name': originalName,
        'name': name,
        'path': path,
        'size': size,
        'full_path': fullPath,
        'mime_type': mimeType,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
