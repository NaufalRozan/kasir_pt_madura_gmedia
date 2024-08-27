import 'dart:convert';

class ProductResponseModel {
    final int? status;
    final String? message;
    final List<Datum>? data;

    ProductResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory ProductResponseModel.fromJson(String str) => ProductResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductResponseModel.fromMap(Map<String, dynamic> json) => ProductResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Datum {
    final String? id;
    final String? categoryId;
    final String? name;
    final int? price;
    final String? pictureUrl;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Datum({
        this.id,
        this.categoryId,
        this.name,
        this.price,
        this.pictureUrl,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"],
        pictureUrl: json["picture_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "price": price,
        "picture_url": pictureUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
