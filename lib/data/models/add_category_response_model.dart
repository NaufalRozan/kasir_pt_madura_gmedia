import 'dart:convert';

class AddCategoryResponseModel {
  final String? message;
  final Data? data;

  AddCategoryResponseModel({
    this.message,
    this.data,
  });

  factory AddCategoryResponseModel.fromJson(String str) =>
      AddCategoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddCategoryResponseModel.fromMap(Map<String, dynamic> json) =>
      AddCategoryResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  final String? name;
  final String? id;

  Data({
    this.name,
    this.id,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
      };
}
