// // To parse this JSON data, do
// //
// //     final productCart = productCartFromMap(jsonString);
//
// import 'dart:convert';
//
// ProductCart productCartFromMap(String str) => ProductCart.fromMap(json.decode(str));
//
// String productCartToMap(ProductCart data) => json.encode(data.toMap());
//
// class ProductCart {
//   ProductCart({
//     this.id,
//     this.active,
//     this.general,
//     this.sku,
//     this.slug,
//     this.name,
//     this.variation,
//     this.mainImage,
//     this.shortDescription,
//     this.largeDescription,
//     this.brandsId,
//     this.categoriesId,
//     this.productTypesId,
//     this.price,
//     this.variationPrices,
//     this.hasVariations,
//     this.isFree,
//     this.isOutStock,
//     this.quantity,
//     this.brands,
//     this.categories,
//     this.productTypes,
//   });
//
//   final String? id;
//   final bool? active;
//   final String? general;
//   final String? sku;
//   final String? slug;
//   final String? name;
//   final Variation? variation;
//   final MainImage? mainImage;
//   final String? shortDescription;
//   final String? largeDescription;
//   final List<String>? brandsId;
//   final List<String>? categoriesId;
//   final List<String>? productTypesId;
//   final Price? price;
//   final VariationPrices? variationPrices;
//   final bool? hasVariations;
//   final bool? isFree;
//   final bool? isOutStock;
//   final int? quantity;
//   final List<Brand>? brands;
//   final List<Brand>? categories;
//   final List<Brand>? productTypes;
//
//   factory ProductCart.fromMap(Map<String, dynamic> json) => ProductCart(
//     id: json["_id"] == null ? null : json["_id"],
//     active: json["active"] == null ? null : json["active"],
//     general: json["general"] == null ? null : json["general"],
//     sku: json["sku"] == null ? null : json["sku"],
//     slug: json["slug"] == null ? null : json["slug"],
//     name: json["name"] == null ? null : json["name"],
//     variation: json["variation"] == null ? null : Variation.fromMap(json["variation"]),
//     mainImage: json["main_image"] == null ? null : MainImage.fromMap(json["main_image"]),
//     shortDescription: json["short_description"] == null ? null : json["short_description"],
//     largeDescription: json["large_description"] == null ? null : json["large_description"],
//     brandsId: json["brands_id"] == null ? null : List<String>.from(json["brands_id"].map((x) => x)),
//     categoriesId: json["categories_id"] == null ? null : List<String>.from(json["categories_id"].map((x) => x)),
//     productTypesId: json["product_types_id"] == null ? null : List<String>.from(json["product_types_id"].map((x) => x)),
//     price: json["price"] == null ? null : Price.fromMap(json["price"]),
//     variationPrices: json["variation_prices"] == null ? null : VariationPrices.fromMap(json["variation_prices"]),
//     hasVariations: json["has_variations"] == null ? null : json["has_variations"],
//     isFree: json["is_free"] == null ? null : json["is_free"],
//     isOutStock: json["is_out_stock"] == null ? null : json["is_out_stock"],
//     quantity: json["quantity"] == null ? null : json["quantity"],
//     brands: json["brands"] == null ? null : List<Brand>.from(json["brands"].map((x) => Brand.fromMap(x))),
//     categories: json["categories"] == null ? null : List<Brand>.from(json["categories"].map((x) => Brand.fromMap(x))),
//     productTypes: json["product_types"] == null ? null : List<Brand>.from(json["product_types"].map((x) => Brand.fromMap(x))),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "_id": id == null ? null : id,
//     "active": active == null ? null : active,
//     "general": general == null ? null : general,
//     "sku": sku == null ? null : sku,
//     "slug": slug == null ? null : slug,
//     "name": name == null ? null : name,
//     "variation": variation == null ? null : variation!.toMap(),
//     "main_image": mainImage == null ? null : mainImage!.toMap(),
//     "short_description": shortDescription == null ? null : shortDescription,
//     "large_description": largeDescription == null ? null : largeDescription,
//     "brands_id": brandsId == null ? null : List<dynamic>.from(brandsId!.map((x) => x)),
//     "categories_id": categoriesId == null ? null : List<dynamic>.from(categoriesId!.map((x) => x)),
//     "product_types_id": productTypesId == null ? null : List<dynamic>.from(productTypesId!.map((x) => x)),
//     "price": price == null ? null : price!.toMap(),
//     "variation_prices": variationPrices == null ? null : variationPrices!.toMap(),
//     "has_variations": hasVariations == null ? null : hasVariations,
//     "is_free": isFree == null ? null : isFree,
//     "is_out_stock": isOutStock == null ? null : isOutStock,
//     "quantity": quantity == null ? null : quantity,
//     "brands": brands == null ? null : List<dynamic>.from(brands!.map((x) => x.toMap())),
//     "categories": categories == null ? null : List<dynamic>.from(categories!.map((x) => x.toMap())),
//     "product_types": productTypes == null ? null : List<dynamic>.from(productTypes!.map((x) => x.toMap())),
//   };
// }
//
// class Brand {
//   Brand({
//     this.id,
//     this.name,
//     this.slug,
//     this.image,
//   });
//
//   final String? id;
//   final String? name;
//   final String? slug;
//   final Image? image;
//
//   factory Brand.fromMap(Map<String, dynamic> json) => Brand(
//     id: json["_id"] == null ? null : json["_id"],
//     name: json["name"] == null ? null : json["name"],
//     slug: json["slug"] == null ? null : json["slug"],
//     image: json["image"] == null ? null : Image.fromMap(json["image"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "_id": id == null ? null : id,
//     "name": name == null ? null : name,
//     "slug": slug == null ? null : slug,
//     "image": image == null ? null : image!.toMap(),
//   };
// }
//
// class Image {
//   Image({
//     this.id,
//     this.src,
//     this.dimensions,
//     this.aspectRatio,
//     this.type,
//     this.format,
//     this.location,
//   });
//
//   final String? id;
//   final String? src;
//   final Dimensions? dimensions;
//   final double? aspectRatio;
//   final String? type;
//   final String? format;
//   final String? location;
//
//   factory Image.fromMap(Map<String, dynamic> json) => Image(
//     id: json["_id"] == null ? null : json["_id"],
//     src: json["src"] == null ? null : json["src"],
//     dimensions: json["dimensions"] == null ? null : Dimensions.fromMap(json["dimensions"]),
//     aspectRatio: json["aspect_ratio"] == null ? null : json["aspect_ratio"].toDouble(),
//     type: json["type"] == null ? null : json["type"],
//     format: json["format"] == null ? null : json["format"],
//     location: json["location"] == null ? null : json["location"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "_id": id == null ? null : id,
//     "src": src == null ? null : src,
//     "dimensions": dimensions == null ? null : dimensions!.toMap(),
//     "aspect_ratio": aspectRatio == null ? null : aspectRatio,
//     "type": type == null ? null : type,
//     "format": format == null ? null : format,
//     "location": location == null ? null : location,
//   };
// }
//
// class Dimensions {
//   Dimensions({
//     this.width,
//     this.height,
//   });
//
//   final double? width;
//   final double? height;
//
//   factory Dimensions.fromMap(Map<String, dynamic> json) => Dimensions(
//     width: json["width"] == null ? null : json["width"].toDouble(),
//     height: json["height"] == null ? null : json["height"].toDouble(),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "width": width == null ? null : width,
//     "height": height == null ? null : height,
//   };
// }
//
// class MainImage {
//   MainImage({
//     this.id,
//     this.src,
//     this.originalName,
//     this.dimensions,
//     this.aspectRatio,
//     this.type,
//     this.format,
//     this.location,
//     this.userCreated,
//     this.userUpdated,
//     this.relations,
//     this.updatedAt,
//     this.createdAt,
//   });
//
//   final String? id;
//   final String? src;
//   final String? originalName;
//   final Dimensions? dimensions;
//   final int? aspectRatio;
//   final String? type;
//   final String? format;
//   final String? location;
//   final String? userCreated;
//   final String? userUpdated;
//   final List<Relation>? relations;
//   final DateTime? updatedAt;
//   final DateTime? createdAt;
//
//   factory MainImage.fromMap(Map<String, dynamic> json) => MainImage(
//     id: json["_id"] == null ? null : json["_id"],
//     src: json["src"] == null ? null : json["src"],
//     originalName: json["original_name"] == null ? null : json["original_name"],
//     dimensions: json["dimensions"] == null ? null : Dimensions.fromMap(json["dimensions"]),
//     aspectRatio: json["aspect_ratio"] == null ? null : json["aspect_ratio"],
//     type: json["type"] == null ? null : json["type"],
//     format: json["format"] == null ? null : json["format"],
//     location: json["location"] == null ? null : json["location"],
//     userCreated: json["user_created"] == null ? null : json["user_created"],
//     userUpdated: json["user_updated"] == null ? null : json["user_updated"],
//     relations: json["relations"] == null ? null : List<Relation>.from(json["relations"].map((x) => Relation.fromMap(x))),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "_id": id == null ? null : id,
//     "src": src == null ? null : src,
//     "original_name": originalName == null ? null : originalName,
//     "dimensions": dimensions == null ? null : dimensions.toMap(),
//     "aspect_ratio": aspectRatio == null ? null : aspectRatio,
//     "type": type == null ? null : type,
//     "format": format == null ? null : format,
//     "location": location == null ? null : location,
//     "user_created": userCreated == null ? null : userCreated,
//     "user_updated": userUpdated == null ? null : userUpdated,
//     "relations": relations == null ? null : List<dynamic>.from(relations.map((x) => x.toMap())),
//     "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
//     "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
//   };
// }
//
// class Relation {
//   Relation({
//     this.relatedId,
//     this.module,
//   });
//
//   final String relatedId;
//   final String module;
//
//   factory Relation.fromMap(Map<String, dynamic> json) => Relation(
//     relatedId: json["related_id"] == null ? null : json["related_id"],
//     module: json["module"] == null ? null : json["module"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "related_id": relatedId == null ? null : relatedId,
//     "module": module == null ? null : module,
//   };
// }
//
// class Price {
//   Price({
//     this.sale,
//     this.regular,
//   });
//
//   final String sale;
//   final String regular;
//
//   factory Price.fromMap(Map<String, dynamic> json) => Price(
//     sale: json["sale"] == null ? null : json["sale"],
//     regular: json["regular"] == null ? null : json["regular"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "sale": sale == null ? null : sale,
//     "regular": regular == null ? null : regular,
//   };
// }
//
// class Variation {
//   Variation({
//     this.id,
//     this.active,
//     this.sku,
//     this.price,
//     this.stockControl,
//     this.stock,
//     this.coincidence,
//     this.attributes,
//   });
//
//   final String id;
//   final bool active;
//   final String sku;
//   final Price price;
//   final bool stockControl;
//   final int stock;
//   final List<String> coincidence;
//   final List<Attribute> attributes;
//
//   factory Variation.fromMap(Map<String, dynamic> json) => Variation(
//     id: json["_id"] == null ? null : json["_id"],
//     active: json["active"] == null ? null : json["active"],
//     sku: json["sku"] == null ? null : json["sku"],
//     price: json["price"] == null ? null : Price.fromMap(json["price"]),
//     stockControl: json["stock_control"] == null ? null : json["stock_control"],
//     stock: json["stock"] == null ? null : json["stock"],
//     coincidence: json["coincidence"] == null ? null : List<String>.from(json["coincidence"].map((x) => x)),
//     attributes: json["attributes"] == null ? null : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromMap(x))),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "_id": id == null ? null : id,
//     "active": active == null ? null : active,
//     "sku": sku == null ? null : sku,
//     "price": price == null ? null : price.toMap(),
//     "stock_control": stockControl == null ? null : stockControl,
//     "stock": stock == null ? null : stock,
//     "coincidence": coincidence == null ? null : List<dynamic>.from(coincidence.map((x) => x)),
//     "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toMap())),
//   };
// }
//
// class Attribute {
//   Attribute({
//     this.id,
//     this.name,
//     this.slug,
//     this.pluralName,
//     this.description,
//     this.image,
//     this.value,
//   });
//
//   final String id;
//   final String name;
//   final String slug;
//   final String pluralName;
//   final String description;
//   final Image image;
//   final Value value;
//
//   factory Attribute.fromMap(Map<String, dynamic> json) => Attribute(
//     id: json["_id"] == null ? null : json["_id"],
//     name: json["name"] == null ? null : json["name"],
//     slug: json["slug"] == null ? null : json["slug"],
//     pluralName: json["plural_name"] == null ? null : json["plural_name"],
//     description: json["description"] == null ? null : json["description"],
//     image: json["image"] == null ? null : Image.fromMap(json["image"]),
//     value: json["value"] == null ? null : Value.fromMap(json["value"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "_id": id == null ? null : id,
//     "name": name == null ? null : name,
//     "slug": slug == null ? null : slug,
//     "plural_name": pluralName == null ? null : pluralName,
//     "description": description == null ? null : description,
//     "image": image == null ? null : image.toMap(),
//     "value": value == null ? null : value.toMap(),
//   };
// }
//
// class Value {
//   Value({
//     this.value,
//     this.label,
//     this.slug,
//     this.hexa,
//     this.id,
//   });
//
//   final String value;
//   final String label;
//   final String slug;
//   final String hexa;
//   final String id;
//
//   factory Value.fromMap(Map<String, dynamic> json) => Value(
//     value: json["value"] == null ? null : json["value"],
//     label: json["label"] == null ? null : json["label"],
//     slug: json["slug"] == null ? null : json["slug"],
//     hexa: json["hexa"] == null ? null : json["hexa"],
//     id: json["_id"] == null ? null : json["_id"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "value": value == null ? null : value,
//     "label": label == null ? null : label,
//     "slug": slug == null ? null : slug,
//     "hexa": hexa == null ? null : hexa,
//     "_id": id == null ? null : id,
//   };
// }
//
// class VariationPrices {
//   VariationPrices({
//     this.regular,
//     this.sale,
//   });
//
//   final Regular regular;
//   final Regular sale;
//
//   factory VariationPrices.fromMap(Map<String, dynamic> json) => VariationPrices(
//     regular: json["regular"] == null ? null : Regular.fromMap(json["regular"]),
//     sale: json["sale"] == null ? null : Regular.fromMap(json["sale"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "regular": regular == null ? null : regular.toMap(),
//     "sale": sale == null ? null : sale.toMap(),
//   };
// }
//
// class Regular {
//   Regular({
//     this.min,
//     this.max,
//   });
//
//   final String min;
//   final String max;
//
//   factory Regular.fromMap(Map<String, dynamic> json) => Regular(
//     min: json["min"] == null ? null : json["min"],
//     max: json["max"] == null ? null : json["max"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "min": min == null ? null : min,
//     "max": max == null ? null : max,
//   };
// }
