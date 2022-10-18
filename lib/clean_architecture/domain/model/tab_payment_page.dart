// To parse this JSON data, do
//
//     final tabPaymentPage = tabPaymentPageFromMap(jsonString);

import 'dart:convert';

TabPaymentPage tabPaymentPageFromMap(String str) => TabPaymentPage.fromMap(json.decode(str));

String tabPaymentPageToMap(TabPaymentPage data) => json.encode(data.toMap());

class TabPaymentPage {
  TabPaymentPage({
    this.checked,
    this.title,
    this.showIcon,
  });

  final bool? checked;
  final String? title;
  final bool? showIcon;

  TabPaymentPage copyWith({
     String? title,
    bool? checked,
    bool? showIcon,
  }) =>
      TabPaymentPage(
        checked: checked ?? this.checked,
        title: title ?? this.title,
      );

  factory TabPaymentPage.fromMap(Map<String, dynamic> json) => TabPaymentPage(
    checked: json["checked"] == null ? null : json["checked"],
    title: json["title"] == null ? null : json["title"],
    showIcon: json["showIcon"] == null ? null : json["showIcon"],
  );

  Map<String, dynamic> toMap() => {
    "checked": checked == null ? null : checked,
    "title": title == null ? null : title,
    "showIcon": showIcon == null ? null : showIcon,
  };
}
