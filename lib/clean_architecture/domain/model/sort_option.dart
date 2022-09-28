// To parse this JSON data, do
//
//     final sortOption = sortOptionFromMap(jsonString);

import 'dart:convert';

SortOption sortOptionFromMap(String str) =>
    SortOption.fromMap(json.decode(str));

String sortOptionToMap(SortOption data) => json.encode(data.toMap());

class SortOption {
  SortOption({
    this.title,
    this.code,
    this.isChecked,
  });

  final String? title;
  final String? code;
  final bool? isChecked;

  SortOption copyWith({
    required bool isChecked,
  }) =>
      SortOption(
        title: title,
        isChecked: isChecked,
      );

  factory SortOption.fromMap(Map<String, dynamic> json) => SortOption(
        title: json["title"] == null ? null : json["title"],
        code: json["code"] == null ? null : json["code"],
        isChecked: json["is_checked"] == null ? null : json["is_checked"],
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "code": code == null ? null : code,
        "is_checked": isChecked == null ? null : isChecked,
      };
}
