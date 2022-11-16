// To parse this JSON data, do
//
//     final order = orderFromMap(jsonString);

import 'dart:convert';

Order orderFromMap(String str) => Order.fromMap(json.decode(str));

String orderToMap(Order data) => json.encode(data.toMap());

class Order {
  Order({
    this.id,
    this.statusDetail,
    this.status,
    this.items,
    this.paymentId,
    this.subTotal,
    this.shipPrice,
    this.transactionAmount,
    this.payer,
    this.utcData,
  });

  final String? id;
  final String? statusDetail;
  final String? status;
  final List<Item>? items;
  final int? paymentId;
  final double? subTotal;
  final double? shipPrice;
  final double? transactionAmount;
  final Payer? payer;
  final String? utcData;

  Order copyWith({
    String? id,
    String? statusDetail,
    String? status,
    List<Item>? items,
    int? paymentId,
    double? subTotal,
    double? shipPrice,
    double? transactionAmount,
    Payer? payer,
    String? utcData,
  }) =>
      Order(
        id: id ?? this.id,
        statusDetail: statusDetail ?? this.statusDetail,
        status: status ?? this.status,
        items: items ?? this.items,
        paymentId: paymentId ?? this.paymentId,
        subTotal: subTotal ?? this.subTotal,
        shipPrice: shipPrice ?? this.shipPrice,
        transactionAmount: transactionAmount ?? this.transactionAmount,
        payer: payer ?? this.payer,
        utcData: utcData ?? this.utcData,
      );

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["_id"] == null ? null : json["_id"],
        statusDetail:
            json["status_detail"] == null ? null : json["status_detail"],
        status: json["status"] == null ? null : json["status"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        paymentId: json["payment_id"] == null ? null : json["payment_id"],
        subTotal:
            json["sub_total"] == null ? null : json["sub_total"].toDouble(),
        shipPrice:
            json["ship_price"] == null ? null : json["ship_price"].toDouble(),
        transactionAmount: json["transaction_amount"] == null
            ? null
            : json["transaction_amount"].toDouble(),
        payer: json["payer"] == null ? null : Payer.fromMap(json["payer"]),
        utcData: json["utc_data"] == null ? null : json["utc_data"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "status_detail": statusDetail == null ? null : statusDetail,
        "status": status == null ? null : status,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "payment_id": paymentId == null ? null : paymentId,
        "sub_total": subTotal == null ? null : subTotal,
        "ship_price": shipPrice == null ? null : shipPrice,
        "transaction_amount":
            transactionAmount == null ? null : transactionAmount,
        "payer": payer == null ? null : payer!.toMap(),
        "utc_data": utcData == null ? null : utcData,
      };
}

class Item {
  Item({
    this.id,
    this.general,
    this.sku,
    this.slug,
    this.name,
    this.isFree,
    this.variationPrices,
    this.variation,
    this.brands,
    this.categories,
    this.productTypes,
    this.mainImage,
    this.price,
    this.quantity,
  });

  final String? id;
  final String? general;
  final String? sku;
  final String? slug;
  final String? name;
  final bool? isFree;
  final VariationPrices? variationPrices;
  final Variation? variation;
  final List<Brand>? brands;
  final List<Brand>? categories;
  final List<Brand>? productTypes;
  final Image? mainImage;
  final ItemPrice? price;
  final int? quantity;

  Item copyWith({
    String? id,
    String? general,
    String? sku,
    String? slug,
    String? name,
    bool? isFree,
    VariationPrices? variationPrices,
    Variation? variation,
    List<Brand>? brands,
    List<Brand>? categories,
    List<Brand>? productTypes,
    Image? mainImage,
    ItemPrice? price,
    int? quantity,
  }) =>
      Item(
        id: id ?? this.id,
        general: general ?? this.general,
        sku: sku ?? this.sku,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        isFree: isFree ?? this.isFree,
        variationPrices: variationPrices ?? this.variationPrices,
        variation: variation ?? this.variation,
        brands: brands ?? this.brands,
        categories: categories ?? this.categories,
        productTypes: productTypes ?? this.productTypes,
        mainImage: mainImage ?? this.mainImage,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
      );

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["_id"] == null ? null : json["_id"],
        general: json["general"] == null ? null : json["general"],
        sku: json["sku"] == null ? null : json["sku"],
        slug: json["slug"] == null ? null : json["slug"],
        name: json["name"] == null ? null : json["name"],
        isFree: json["is_free"] == null ? null : json["is_free"],
        variationPrices: json["variation_prices"] == null
            ? null
            : VariationPrices.fromMap(json["variation_prices"]),
        variation: json["variation"] == null
            ? null
            : Variation.fromMap(json["variation"]),
        brands: json["brands"] == null
            ? null
            : List<Brand>.from(json["brands"].map((x) => Brand.fromMap(x))),
        categories: json["categories"] == null
            ? null
            : List<Brand>.from(json["categories"].map((x) => Brand.fromMap(x))),
        productTypes: json["product_types"] == null
            ? null
            : List<Brand>.from(
                json["product_types"].map((x) => Brand.fromMap(x))),
        mainImage: json["main_image"] == null
            ? null
            : Image.fromMap(json["main_image"]),
        price: json["price"] == null ? null : ItemPrice.fromMap(json["price"]),
        quantity: json["quantity"] == null ? null : json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "general": general == null ? null : general,
        "sku": sku == null ? null : sku,
        "slug": slug == null ? null : slug,
        "name": name == null ? null : name,
        "is_free": isFree == null ? null : isFree,
        "variation_prices":
            variationPrices == null ? null : variationPrices!.toMap(),
        "variation": variation == null ? null : variation!.toMap(),
        "brands": brands == null
            ? null
            : List<dynamic>.from(brands!.map((x) => x.toMap())),
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toMap())),
        "product_types": productTypes == null
            ? null
            : List<dynamic>.from(productTypes!.map((x) => x.toMap())),
        "main_image": mainImage == null ? null : mainImage!.toMap(),
        "price": price == null ? null : price!.toMap(),
        "quantity": quantity == null ? null : quantity,
      };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.slug,
    this.image,
  });

  final String? id;
  final String? name;
  final String? slug;
  final Image? image;

  Brand copyWith({
    String? id,
    String? name,
    String? slug,
    Image? image,
  }) =>
      Brand(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        image: image ?? this.image,
      );

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        image: json["image"] == null ? null : Image.fromMap(json["image"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "image": image == null ? null : image!.toMap(),
      };
}

class Image {
  Image({
    this.id,
    this.src,
    this.dimensions,
    this.aspectRatio,
    this.type,
    this.format,
  });

  final String? id;
  final String? src;
  final Dimensions? dimensions;
  final int? aspectRatio;
  final String? type;
  final String? format;

  Image copyWith({
    String? id,
    String? src,
    Dimensions? dimensions,
    int? aspectRatio,
    String? type,
    String? format,
  }) =>
      Image(
        id: id ?? this.id,
        src: src ?? this.src,
        dimensions: dimensions ?? this.dimensions,
        aspectRatio: aspectRatio ?? this.aspectRatio,
        type: type ?? this.type,
        format: format ?? this.format,
      );

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        id: json["_id"] == null ? null : json["_id"],
        src: json["src"] == null ? null : json["src"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromMap(json["dimensions"]),
        aspectRatio: json["aspect_ratio"] == null ? null : json["aspect_ratio"],
        type: json["type"] == null ? null : json["type"],
        format: json["format"] == null ? null : json["format"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "src": src == null ? null : src,
        "dimensions": dimensions == null ? null : dimensions!.toMap(),
        "aspect_ratio": aspectRatio == null ? null : aspectRatio,
        "type": type == null ? null : type,
        "format": format == null ? null : format,
      };
}

class Dimensions {
  Dimensions({
    this.width,
    this.height,
  });

  final int? width;
  final int? height;

  Dimensions copyWith({
    int? width,
    int? height,
  }) =>
      Dimensions(
        width: width ?? this.width,
        height: height ?? this.height,
      );

  factory Dimensions.fromMap(Map<String, dynamic> json) => Dimensions(
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
      );

  Map<String, dynamic> toMap() => {
        "width": width == null ? null : width,
        "height": height == null ? null : height,
      };
}

class ItemPrice {
  ItemPrice({
    this.regular,
    this.sale,
  });

  final String? regular;
  final String? sale;

  ItemPrice copyWith({
    String? regular,
    String? sale,
  }) =>
      ItemPrice(
        regular: regular ?? this.regular,
        sale: sale ?? this.sale,
      );

  factory ItemPrice.fromMap(Map<String, dynamic> json) => ItemPrice(
        regular: json["regular"] == null ? null : json["regular"],
        sale: json["sale"] == null ? null : json["sale"],
      );

  Map<String, dynamic> toMap() => {
        "regular": regular == null ? null : regular,
        "sale": sale == null ? null : sale,
      };
}

class Variation {
  Variation({
    this.id,
    this.active,
    this.sku,
    this.price,
    this.stockControl,
    this.stock,
    this.coincidence,
    this.variationDefault,
    this.attributes,
  });

  final String? id;
  final bool? active;
  final String? sku;
  final VariationPrice? price;
  final bool? stockControl;
  final int? stock;
  final List<String>? coincidence;
  final bool? variationDefault;
  final List<Attribute>? attributes;

  Variation copyWith({
    String? id,
    bool? active,
    String? sku,
    VariationPrice? vprice,
    bool? stockControl,
    int? stock,
    List<String>? coincidence,
    bool? variationDefault,
    List<Attribute>? attributes,
  }) =>
      Variation(
        id: id ?? this.id,
        active: active ?? this.active,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        stockControl: stockControl ?? this.stockControl,
        stock: stock ?? this.stock,
        coincidence: coincidence ?? this.coincidence,
        variationDefault: variationDefault ?? this.variationDefault,
        attributes: attributes ?? this.attributes,
      );

  factory Variation.fromMap(Map<String, dynamic> json) => Variation(
        id: json["_id"] == null ? null : json["_id"],
        active: json["active"] == null ? null : json["active"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"] == null
            ? null
            : VariationPrice.fromMap(json["price"]),
        stockControl:
            json["stock_control"] == null ? null : json["stock_control"],
        stock: json["stock"] == null ? null : json["stock"],
        coincidence: json["coincidence"] == null
            ? null
            : List<String>.from(json["coincidence"].map((x) => x)),
        variationDefault: json["default"] == null ? null : json["default"],
        attributes: json["attributes"] == null
            ? null
            : List<Attribute>.from(
                json["attributes"].map((x) => Attribute.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "active": active == null ? null : active,
        "sku": sku == null ? null : sku,
        "price": price == null ? null : price!.toMap(),
        "stock_control": stockControl == null ? null : stockControl,
        "stock": stock == null ? null : stock,
        "coincidence": coincidence == null
            ? null
            : List<dynamic>.from(coincidence!.map((x) => x)),
        "default": variationDefault == null ? null : variationDefault,
        "attributes": attributes == null
            ? null
            : List<dynamic>.from(attributes!.map((x) => x.toMap())),
      };
}

class Attribute {
  Attribute({
    this.id,
    this.name,
    this.pluralName,
    this.description,
    this.slug,
    this.term,
    this.image,
  });

  final String? id;
  final String? name;
  final String? pluralName;
  final String? description;
  final String? slug;
  final Term? term;
  final Image? image;

  Attribute copyWith({
    String? id,
    String? name,
    String? pluralName,
    String? description,
    String? slug,
    Term? term,
    Image? image,
  }) =>
      Attribute(
        id: id ?? this.id,
        name: name ?? this.name,
        pluralName: pluralName ?? this.pluralName,
        description: description ?? this.description,
        slug: slug ?? this.slug,
        term: term ?? this.term,
        image: image ?? this.image,
      );

  factory Attribute.fromMap(Map<String, dynamic> json) => Attribute(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        pluralName: json["plural_name"] == null ? null : json["plural_name"],
        description: json["description"] == null ? null : json["description"],
        slug: json["slug"] == null ? null : json["slug"],
        term: json["term"] == null ? null : Term.fromMap(json["term"]),
        image: json["image"] == null ? null : Image.fromMap(json["image"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "plural_name": pluralName == null ? null : pluralName,
        "description": description == null ? null : description,
        "slug": slug == null ? null : slug,
        "term": term == null ? null : term!.toMap(),
        "image": image == null ? null : image!.toMap(),
      };
}

class Term {
  Term({
    this.value,
    this.label,
    this.slug,
    this.hexa,
    this.id,
  });

  final String? value;
  final String? label;
  final String? slug;
  final String? hexa;
  final String? id;

  Term copyWith({
    String? value,
    String? label,
    String? slug,
    String? hexa,
    String? id,
  }) =>
      Term(
        value: value ?? this.value,
        label: label ?? this.label,
        slug: slug ?? this.slug,
        hexa: hexa ?? this.hexa,
        id: id ?? this.id,
      );

  factory Term.fromMap(Map<String, dynamic> json) => Term(
        value: json["value"] == null ? null : json["value"],
        label: json["label"] == null ? null : json["label"],
        slug: json["slug"] == null ? null : json["slug"],
        hexa: json["hexa"] == null ? null : json["hexa"],
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "value": value == null ? null : value,
        "label": label == null ? null : label,
        "slug": slug == null ? null : slug,
        "hexa": hexa == null ? null : hexa,
        "_id": id == null ? null : id,
      };
}

class VariationPrice {
  VariationPrice({
    this.regular,
    this.sale,
  });

  final double? regular;
  final double? sale;

  VariationPrice copyWith({
    double? regular,
    double? sale,
  }) =>
      VariationPrice(
        regular: regular ?? this.regular,
        sale: sale ?? this.sale,
      );

  factory VariationPrice.fromMap(Map<String, dynamic> json) => VariationPrice(
        regular: json["regular"] == null ? null : json["regular"].toDouble(),
        sale: json["sale"] == null ? null : json["sale"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "regular": regular == null ? null : regular,
        "sale": sale == null ? null : sale,
      };
}

class VariationPrices {
  VariationPrices({
    this.regular,
    this.sale,
  });

  final Regular? regular;
  final Regular? sale;

  VariationPrices copyWith({
    Regular? regular,
    Regular? sale,
  }) =>
      VariationPrices(
        regular: regular ?? this.regular,
        sale: sale ?? this.sale,
      );

  factory VariationPrices.fromMap(Map<String, dynamic> json) => VariationPrices(
        regular:
            json["regular"] == null ? null : Regular.fromMap(json["regular"]),
        sale: json["sale"] == null ? null : Regular.fromMap(json["sale"]),
      );

  Map<String, dynamic> toMap() => {
        "regular": regular == null ? null : regular!.toMap(),
        "sale": sale == null ? null : sale!.toMap(),
      };
}

class Regular {
  Regular({
    this.min,
    this.max,
  });

  final double? min;
  final double? max;

  Regular copyWith({
    double? min,
    double? max,
  }) =>
      Regular(
        min: min ?? this.min,
        max: max ?? this.max,
      );

  factory Regular.fromMap(Map<String, dynamic> json) => Regular(
        min: json["min"] == null ? null : json["min"],
        max: json["max"] == null ? null : json["max"],
      );

  Map<String, dynamic> toMap() => {
        "min": min == null ? null : min,
        "max": max == null ? null : max,
      };
}

class Payer {
  Payer({
    this.direction,
    this.referenceName,
    this.addressType,
    this.lotNumber,
    this.dptoInt,
    this.urbanName,
    this.province,
    this.department,
    this.district,
  });

  final String? direction;
  final String? referenceName;
  final String? addressType;
  final int? lotNumber;
  final int? dptoInt;
  final String? urbanName;
  final String? province;
  final String? department;
  final String? district;

  Payer copyWith({
    String? direction,
    String? referenceName,
    String? addressType,
    int? lotNumber,
    int? dptoInt,
    String? urbanName,
    String? province,
    String? department,
    String? district,
  }) =>
      Payer(
        direction: direction ?? this.direction,
        referenceName: referenceName ?? this.referenceName,
        addressType: addressType ?? this.addressType,
        lotNumber: lotNumber ?? this.lotNumber,
        dptoInt: dptoInt ?? this.dptoInt,
        urbanName: urbanName ?? this.urbanName,
        province: province ?? this.province,
        department: department ?? this.department,
        district: district ?? this.district,
      );

  factory Payer.fromMap(Map<String, dynamic> json) => Payer(
        direction: json["direction"] == null ? null : json["direction"],
        referenceName:
            json["reference_name"] == null ? null : json["reference_name"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        lotNumber: json["lot_number"] == null ? null : json["lot_number"],
        dptoInt: json["dpto_int"] == null ? null : json["dpto_int"],
        urbanName: json["urban_name"] == null ? null : json["urban_name"],
        province: json["province"] == null ? null : json["province"],
        department: json["department"] == null ? null : json["department"],
        district: json["district"] == null ? null : json["district"],
      );

  Map<String, dynamic> toMap() => {
        "direction": direction == null ? null : direction,
        "reference_name": referenceName == null ? null : referenceName,
        "address_type": addressType == null ? null : addressType,
        "lot_number": lotNumber == null ? null : lotNumber,
        "dpto_int": dptoInt == null ? null : dptoInt,
        "urban_name": urbanName == null ? null : urbanName,
        "province": province == null ? null : province,
        "department": department == null ? null : department,
        "district": district == null ? null : district,
      };
}
