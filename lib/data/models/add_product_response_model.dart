import 'dart:convert';

class AddProductResponseModel {
  final String? message;
  final Data? data;

  AddProductResponseModel({
    this.message,
    this.data,
  });

  factory AddProductResponseModel.fromJson(String str) =>
      AddProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddProductResponseModel.fromMap(Map<String, dynamic> json) =>
      AddProductResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  final String? categoryId;
  final String? name;
  final String? price;
  final String? pictureUrl;
  final String? id;

  Data({
    this.categoryId,
    this.name,
    this.price,
    this.pictureUrl,
    this.id,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"],
        pictureUrl: json["picture_url"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoryId,
        "name": name,
        "price": price,
        "picture_url": pictureUrl,
        "id": id,
      };
}
