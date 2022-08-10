// To parse this JSON data, do
//
//     final comment = commentFromMap(jsonString);

import 'dart:convert';

Comment commentFromMap(String str) => Comment.fromMap(json.decode(str));

String commentToMap(Comment data) => json.encode(data.toMap());

class Comment {
  Comment({
    this.id,
    this.productId,
    this.comments,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? productId;
  final List<CommentElement>? comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: json["_id"] == null ? null : json["_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        comments: json["comments"] == null
            ? null
            : List<CommentElement>.from(
                json["comments"].map((x) => CommentElement.fromMap(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x.toMap())),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

class CommentElement {
  CommentElement({
    this.userId,
    this.name,
    this.message,
    this.valoration,
    this.imageUrl,
    this.children,
    this.date,
    this.id,
  });

  final String? userId;
  final String? name;
  final String? message;
  final int? valoration;
  final String? imageUrl;
  final List<Child>? children;
  final DateTime? date;
  final String? id;

  factory CommentElement.fromMap(Map<String, dynamic> json) => CommentElement(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        message: json["message"] == null ? null : json["message"],
        valoration: json["valoration"] == null ? null : json["valoration"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        children: json["children"] == null
            ? null
            : List<Child>.from(json["children"].map((x) => Child.fromMap(x))),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "message": message == null ? null : message,
        "valoration": valoration == null ? null : valoration,
        "image_url": imageUrl == null ? null : imageUrl,
        "children": children == null
            ? []
            : List<dynamic>.from(children!.map((x) => x.toMap())),
        "date": date == null ? null : date!.toIso8601String(),
        "_id": id == null ? null : id,
      };
}

class Child {
  Child({
    this.userId,
    this.name,
    this.message,
    this.imageUrl,
    this.id,
  });

  final String? userId;
  final String? name;
  final String? message;
  final String? imageUrl;
  final String? id;

  factory Child.fromMap(Map<String, dynamic> json) => Child(
        userId: json["user_id"] == null ? null : json["user_id"],
        name: json["name"] == null ? null : json["name"],
        message: json["message"] == null ? null : json["message"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "name": name == null ? null : name,
        "message": message == null ? null : message,
        "image_url": imageUrl == null ? null : imageUrl,
        "_id": id == null ? null : id,
      };
}
