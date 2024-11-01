// To parse this JSON data, do
//
//     final profileblockuser = profileblockuserFromJson(jsonString);

import 'dart:convert';

ProfileBlockUser profileblockuserFromJson(String str) => ProfileBlockUser.fromJson(json.decode(str));

String profileblockuserToJson(ProfileBlockUser data) => json.encode(data.toJson());

class ProfileBlockUser {
  String? responseCode;
  String? result;
  String? responseMsg;

  ProfileBlockUser({
    this.responseCode,
    this.result,
    this.responseMsg,
  });

  factory ProfileBlockUser.fromJson(Map<String, dynamic> json) => ProfileBlockUser(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
