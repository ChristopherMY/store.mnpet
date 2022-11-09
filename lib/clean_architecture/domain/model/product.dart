// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

Product productFromMap(String str) => Product.fromMap(json.decode(str));

String productToMap(Product data) => json.encode(data.toMap());

class Product {
  Product({
    this.id,
    this.general,
    this.sku,
    this.slug,
    this.name,
    this.attributesDescription,
    this.attributes,
    this.modalAttributes,
    this.variations,
    this.variation,
    this.mainImage,
    this.galleryHeader,
    this.galleryDescription,
    this.shortDescription,
    this.largeDescription,
    this.stock,
    this.specifications,
    this.hasCombos,
    this.hasVariations,
    this.variationPrices,
    this.isFree,
    this.showInStore,
    this.galleryVideo,
    this.price,
    this.brands,
    this.categories,
    this.productTypes,
    this.rating,
    this.popularity,
    this.quantity,
    this.totalPurchased,
    this.combosSettings,
    this.combos,
  });

  final String? id;
  final String? general;
  final String? sku;
  final String? slug;
  final String? name;
  final String? attributesDescription;
  List<ProductAttribute>? attributes;
  List<ProductAttribute>? modalAttributes;
  List<Variation>? variations;
  final VariationCart? variation;
  final MainImage? mainImage;
  final List<MainImage>? galleryHeader;
  final String? shortDescription;
  final String? largeDescription;
  final int? stock;
  final List<Specification>? specifications;
  final List<MainImage>? galleryDescription;
  final bool? hasCombos;
  final bool? hasVariations;
  final VariationPrices? variationPrices;
  final bool? isFree;
  final bool? showInStore;
  final List<GalleryVideo>? galleryVideo;
  final Price? price;
  final List<Brand>? brands;
  final List<Brand>? categories;
  final List<Brand>? productTypes;
  final int? rating;
  final int? popularity;
  int? quantity;
  final int? totalPurchased;
  final List<dynamic>? combosSettings;
  final List<dynamic>? combos;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["_id"] == null ? null : json["_id"],
        general: json["general"] == null ? null : json["general"],
        sku: json["sku"] == null ? null : json["sku"],
        slug: json["slug"] == null ? null : json["slug"],
        name: json["name"] == null ? null : json["name"],
        attributesDescription: json["attributes_description"] == null
            ? null
            : json["attributes_description"],
        attributes: json["attributes"] == null
            ? null
            : List<ProductAttribute>.from(
                json["attributes"].map((x) => ProductAttribute.fromMap(x))),
        modalAttributes: json["attributes"] == null
            ? null
            : List<ProductAttribute>.from(
                json["attributes"].map((x) => ProductAttribute.fromMap(x))),
        variations: json["variations"] == null
            ? null
            : List<Variation>.from(
                json["variations"].map((x) => Variation.fromMap(x))),
        variation: json["variation"] == null
            ? null
            : VariationCart.fromMap(json["variation"]),
        mainImage: json["main_image"] == null
            ? null
            : MainImage.fromMap(json["main_image"]),
        galleryHeader: json["gallery_header"] == null
            ? null
            : List<MainImage>.from(
                json["gallery_header"].map((x) => MainImage.fromMap(x))),
        shortDescription: json["short_description"] == null
            ? null
            : json["short_description"],
        largeDescription: json["large_description"] == null
            ? null
            : json["large_description"],
        stock: json["stock"] == null ? null : json["stock"],
        specifications: json["specifications"] == null
            ? null
            : List<Specification>.from(
                json["specifications"].map((x) => Specification.fromMap(x))),
        hasCombos: json["has_combos"] == null ? null : json["has_combos"],
        hasVariations:
            json["has_variations"] == null ? null : json["has_variations"],
        variationPrices: json["variation_prices"] == null
            ? null
            : VariationPrices.fromMap(json["variation_prices"]),
        isFree: json["is_free"] == null ? null : json["is_free"],
        showInStore:
            json["show_in_store"] == null ? null : json["show_in_store"],
        galleryVideo: json["gallery_video"] == null
            ? []
            : List<GalleryVideo>.from(
                json["gallery_video"].map((x) => GalleryVideo.fromMap(x))),
        galleryDescription: json["gallery_description"] == null
            ? null
            : List<MainImage>.from(
                json["gallery_description"].map((x) => MainImage.fromMap(x))),
        price: json["price"] == null ? null : Price.fromMap(json["price"]),
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
        rating: json["rating"] == null ? null : json["rating"],
        popularity: json["popularity"] == null ? null : json["popularity"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        totalPurchased:
            json["total_purchased"] == null ? null : json["total_purchased"],
        combosSettings: json["combos_settings"] == null
            ? null
            : List<dynamic>.from(json["combos_settings"].map((x) => x)),
        combos: json["combos"] == null
            ? null
            : List<dynamic>.from(json["combos"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "general": general == null ? null : general,
        "sku": sku == null ? null : sku,
        "slug": slug == null ? null : slug,
        "name": name == null ? null : name,
        "attributes_description":
            attributesDescription == null ? null : attributesDescription,
        "attributes": attributes == null
            ? null
            : List<dynamic>.from(attributes!.map((x) => x.toMap())),
        "modal_attributes": modalAttributes == null
            ? null
            : List<dynamic>.from(modalAttributes!.map((x) => x.toMap())),
        "variations": variations == null
            ? null
            : List<dynamic>.from(variations!.map((x) => x.toMap())),
        "variation": variation == null ? null : variation!.toMap(),
        "main_image": mainImage == null ? null : mainImage!.toMap(),
        "gallery_header": galleryHeader == null
            ? null
            : List<dynamic>.from(galleryHeader!.map((x) => x.toMap())),
        "gallery_description": galleryDescription == null
            ? null
            : List<dynamic>.from(galleryDescription!.map((x) => x.toMap())),
        "short_description": shortDescription == null ? null : shortDescription,
        "large_description": largeDescription == null ? null : largeDescription,
        "stock": stock == null ? null : stock,
        "specifications": specifications == null
            ? null
            : List<dynamic>.from(specifications!.map((x) => x.toMap())),
        "has_combos": hasCombos == null ? null : hasCombos,
        "has_variations": hasVariations == null ? null : hasVariations,
        "variation_prices":
            variationPrices == null ? null : variationPrices!.toMap(),
        "is_free": isFree == null ? null : isFree,
        "show_in_store": showInStore == null ? null : showInStore,
        "gallery_video": galleryVideo == null
            ? []
            : List<dynamic>.from(galleryVideo!.map((x) => x.toMap())),
        "price": price == null ? null : price!.toMap(),
        "brands": brands == null
            ? null
            : List<dynamic>.from(brands!.map((x) => x.toMap())),
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toMap())),
        "product_types": productTypes == null
            ? null
            : List<dynamic>.from(productTypes!.map((x) => x.toMap())),
        "rating": rating == null ? null : rating,
        "popularity": popularity == null ? null : popularity,
        "quantity": quantity == null ? null : quantity,
        "total_purchased": totalPurchased == null ? null : totalPurchased,
        "combos_settings": combosSettings == null
            ? null
            : List<dynamic>.from(combosSettings!.map((x) => x)),
        "combos":
            combos == null ? null : List<dynamic>.from(combos!.map((x) => x)),
      };
}

class ProductAttribute {
  ProductAttribute({
    this.id,
    this.attributeId,
    this.name,
    this.slug,
    this.description,
    this.pluralName,
    this.terms,
    this.checkedName,
    this.termsSelected,
  });

  final String? id;
  final String? attributeId;
  final String? name;
  final String? slug;
  final String? description;
  final String? pluralName;
  List<Term>? terms;
  List<Term>? termsSelected;
  String? checkedName;

  factory ProductAttribute.fromMap(Map<String, dynamic> json) =>
      ProductAttribute(
        id: json["_id"] == null ? null : json["_id"],
        attributeId: json["attribute_id"] == null ? null : json["attribute_id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"] == null ? null : json["description"],
        pluralName: json["plural_name"] == null ? null : json["plural_name"],
        checkedName: json["checked_name"] == null ? null : json["checked_name"],
        terms: json["terms"] == null
            ? null
            : List<Term>.from(json["terms"].map((x) => Term.fromMap(x))),
        termsSelected: json["terms_selected"] == null
            ? []
            : List<Term>.from(
                json["terms_selected"].map((x) => Term.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "attribute_id": attributeId == null ? null : attributeId,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description == null ? null : description,
        "plural_name": pluralName == null ? null : pluralName,
        "checked_name": checkedName == null ? null : checkedName,
        "terms": terms == null
            ? null
            : List<dynamic>.from(terms!.map((x) => x.toMap())),
        "terms_selected": termsSelected == null
            ? []
            : List<dynamic>.from(termsSelected!.map((x) => x.toMap())),
      };

  ProductAttribute copyWith({
    String? id,
    String? attributeId,
    String? name,
    String? slug,
    String? description,
    String? pluralName,
    List<Term>? terms,
    String? checkedName,
    List<Term>? termsSelected,
  }) {
    return ProductAttribute(
      id: id ?? this.id,
      attributeId: attributeId ?? this.attributeId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      pluralName: pluralName ?? this.pluralName,
      terms: terms ?? this.terms,
      checkedName: checkedName ?? this.checkedName,
      termsSelected: terms ?? this.termsSelected,
    );
  }
}

class Term {
  Term({
    this.value,
    this.label,
    this.slug,
    this.hexa,
    this.id,
    this.image,
    this.hasBorder,
    this.checked,
    this.count,
  });

  final String? value;
  final String? label;
  final String? slug;
  final String? hexa;
  final String? id;
  final MainImage? image;
  bool? hasBorder;
  bool? checked;
  int? count;

  factory Term.fromMap(Map<String, dynamic> json) => Term(
        value: json["value"] == null ? null : json["value"],
        label: json["label"] == null ? null : json["label"],
        slug: json["slug"] == null ? null : json["slug"],
        hexa: json["hexa"] == null ? null : json["hexa"],
        id: json["_id"] == null ? null : json["_id"],
        hasBorder: json["has_border"] ?? false,
        image: json["image"] == null ? null : MainImage.fromMap(json["image"]),
        checked: json["checked"] ?? false,
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "value": value == null ? null : value,
        "label": label == null ? null : label,
        "slug": slug == null ? null : slug,
        "hexa": hexa == null ? null : hexa,
        "_id": id == null ? null : id,
        "has_border": hasBorder ?? false,
        "image": image == null ? null : image!.toMap(),
        "checked": checked ?? false,
        "count": count ?? 0,
      };

  Term copyWith({
    String? value,
    String? label,
    String? slug,
    String? hexa,
    String? id,
    MainImage? image,
    bool? hasBorder,
    bool? checked,
    int? count,
  }) {
    return Term(
      value: value ?? this.value,
      label: label ?? this.label,
      slug: slug ?? this.slug,
      hexa: hexa ?? this.hexa,
      id: id ?? this.id,
      image: image ?? this.image,
      hasBorder: hasBorder ?? this.hasBorder,
      checked: checked ?? this.checked,
      count: count ?? this.count,
    );
  }
}

class MainImage {
  MainImage({
    this.id,
    this.src,
    this.dimensions,
    this.aspectRatio,
    this.type,
    this.format,
    this.key,
    this.order,
  });

  final String? id;
  final String? src;
  final Dimensions? dimensions;
  final double? aspectRatio;
  final String? type;
  final String? format;
  final String? key;
  final int? order;

  factory MainImage.fromMap(Map<String, dynamic> json) => MainImage(
        id: json["_id"] == null ? null : json["_id"],
        src: json["src"] == null ? null : json["src"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromMap(json["dimensions"]),
        aspectRatio: json["aspect_ratio"] == null
            ? 1.38
            : json["aspect_ratio"].toDouble(),
        type: json["type"] == null ? null : json["type"],
        format: json["format"] == null ? null : json["format"],
        key: json["key"] == null ? null : json["key"],
        order: json["order"] == null ? null : json["order"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "src": src == null ? null : src,
        "dimensions": dimensions == null ? null : dimensions!.toMap(),
        "aspect_ratio": aspectRatio == null ? 0.88 : aspectRatio,
        "type": type == null ? null : type,
        "format": format == null ? null : format,
        "key": key == null ? null : key,
        "order": order == null ? null : order,
      };
}

class Dimensions {
  Dimensions({
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  factory Dimensions.fromMap(Map<String, dynamic> json) => Dimensions(
        width: json["width"] == null ? null : json["width"].toDouble(),
        height: json["height"] == null ? null : json["height"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "width": width == null ? null : width,
        "height": height == null ? null : height,
      };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.checked,
    this.count,
  });

  final String? id;
  final String? name;
  final String? slug;
  final MainImage? image;
  final bool? checked;
  final int? count;

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        image: json["image"] == null ? null : MainImage.fromMap(json["image"]),
        checked: json["checked"] ?? false,
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "image": image == null ? null : image!.toMap(),
        "checked": checked ?? false,
        "count": count ?? 0,
      };

  Brand copyWith({
    String? id,
    String? name,
    String? slug,
    MainImage? image,
    bool? checked,
    int? count,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      image: image ?? this.image,
      checked: checked ?? this.checked,
      count: count ?? this.count,
    );
  }
}

class GalleryVideo {
  GalleryVideo({
    this.src,
    this.url,
    this.type,
    this.dimensions,
    this.aspectRatio,
    this.thumb,
    this.title,
    this.duration,
    this.order,
    this.id,
  });

  final String? src;
  final String? url;
  final String? type;
  final Dimensions? dimensions;
  final double? aspectRatio;
  final String? thumb;
  final String? title;
  final double? duration;
  final int? order;
  final String? id;

  factory GalleryVideo.fromMap(Map<String, dynamic> json) => GalleryVideo(
        src: json["src"] == null ? null : json["src"],
        url: json["url"] == null ? null : json["url"],
        type: json["type"] == null ? null : json["type"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromMap(json["dimensions"]),
        aspectRatio: json["aspect_ratio"] == null
            ? null
            : json["aspect_ratio"].toDouble(),
        thumb: json["thumb"] == null ? null : json["thumb"],
        title: json["title"] == null ? null : json["title"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        order: json["order"] == null ? null : json["order"],
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "src": src == null ? null : src,
        "url": url == null ? null : url,
        "type": type == null ? null : type,
        "dimensions": dimensions == null ? null : dimensions!.toMap(),
        "aspect_ratio": aspectRatio == null ? null : aspectRatio,
        "thumb": thumb == null ? null : thumb,
        "title": title == null ? null : title,
        "duration": duration == null ? null : duration,
        "order": order == null ? null : order,
        "_id": id == null ? null : id,
      };
}

class Price {
  Price({
    this.regular,
    this.sale,
  });

  final String? regular;
  final String? sale;

  factory Price.fromMap(Map<String, dynamic> json) => Price(
        regular: json["regular"] == null ? null : json["regular"].toString(),
        sale: json["sale"] == null ? null : json["sale"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "regular": regular == null ? null : regular,
        "sale": sale == null ? null : sale,
      };
}

class Specification {
  Specification({
    this.header,
    this.body,
    this.id,
  });

  final String? header;
  final String? body;
  final String? id;

  factory Specification.fromMap(Map<String, dynamic> json) => Specification(
        header: json["header"] == null ? null : json["header"],
        body: json["body"] == null ? null : json["body"],
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "header": header == null ? null : header,
        "body": body == null ? null : body,
        "_id": id == null ? null : id,
      };
}

class VariationPrices {
  VariationPrices({
    this.regular,
    this.sale,
  });

  final Regular? regular;
  final Regular? sale;

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

  final String? min;
  final String? max;

  factory Regular.fromMap(Map<String, dynamic> json) => Regular(
        min: json["min"] == null ? null : json["min"],
        max: json["max"] == null ? null : json["max"],
      );

  Map<String, dynamic> toMap() => {
        "min": min == null ? null : min,
        "max": max == null ? null : max,
      };
}

class Variation {
  Variation({
    this.id,
    this.attributes,
    this.variationDefault,
    this.active,
    this.sku,
    this.price,
    this.coincidence,
  });

  final String? id;
  List<VariationAttribute>? attributes;
  bool? variationDefault;
  final bool? active;
  final String? sku;
  final Price? price;
  final List<String>? coincidence;

  factory Variation.fromMap(Map<String, dynamic> json) => Variation(
        id: json["_id"] == null ? null : json["_id"],
        attributes: json["attributes"] == null
            ? null
            : List<VariationAttribute>.from(
                json["attributes"].map((x) => VariationAttribute.fromMap(x))),
        variationDefault: json["default"] == null ? null : json["default"],
        active: json["active"] == null ? null : json["active"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"] == null ? null : Price.fromMap(json["price"]),
        coincidence: json["coincidence"] == null
            ? null
            : List<String>.from(json["coincidence"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "attributes": attributes == null
            ? null
            : List<dynamic>.from(attributes!.map((x) => x.toMap())),
        "default": variationDefault == null ? null : variationDefault,
        "active": active == null ? null : active,
        "sku": sku == null ? null : sku,
        "price": price == null ? null : price!.toMap(),
        "coincidence": coincidence == null
            ? null
            : List<dynamic>.from(coincidence!.map((x) => x)),
      };
}

class VariationAttribute {
  VariationAttribute({
    this.id,
    this.name,
    this.pluralName,
    this.description,
    this.pluralSlug,
    this.slug,
    this.value,
    this.image,
  });

  final String? id;
  final String? name;
  final String? pluralName;
  final String? description;
  final String? pluralSlug;
  final String? slug;
  final Term? value;
  final MainImage? image;

  factory VariationAttribute.fromMap(Map<String, dynamic> json) =>
      VariationAttribute(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        pluralName: json["plural_name"] == null ? null : json["plural_name"],
        description: json["description"] == null ? null : json["description"],
        pluralSlug: json["plural_slug"] == null ? null : json["plural_slug"],
        slug: json["slug"] == null ? null : json["slug"],
        value: json["value"] == null ? null : Term.fromMap(json["value"]),
        image: json["image"] == null ? null : MainImage.fromMap(json["image"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "plural_name": pluralName == null ? null : pluralName,
        "description": description == null ? null : description,
        "plural_slug": pluralSlug == null ? null : pluralSlug,
        "slug": slug == null ? null : slug,
        "value": value == null ? null : value!.toMap(),
        "image": image == null ? null : image!.toMap(),
      };
}

class VariationCart {
  VariationCart({
    this.id,
    this.active,
    this.sku,
    this.price,
    this.stockControl,
    this.stock,
    this.coincidence,
    this.attributes,
  });

  final String? id;
  final bool? active;
  final String? sku;
  final Price? price;
  final bool? stockControl;
  final int? stock;
  final List<String>? coincidence;
  final List<VariationAttribute>? attributes;

  factory VariationCart.fromMap(Map<String, dynamic> json) => VariationCart(
        id: json["_id"] == null ? null : json["_id"],
        active: json["active"] == null ? null : json["active"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"] == null ? null : Price.fromMap(json["price"]),
        stockControl:
            json["stock_control"] == null ? null : json["stock_control"],
        stock: json["stock"] == null ? null : json["stock"],
        coincidence: json["coincidence"] == null
            ? null
            : List<String>.from(json["coincidence"].map((x) => x)),
        attributes: json["attributes"] == null
            ? null
            : List<VariationAttribute>.from(
                json["attributes"].map((x) => VariationAttribute.fromMap(x))),
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
        "attributes": attributes == null
            ? null
            : List<dynamic>.from(attributes!.map((x) => x.toMap())),
      };
}
