import 'dart:convert';
import 'dart:typed_data';

class ProductModel {
  final String categoryID;
  final String categoryName;
  final String supplierID;
  final String productID;
  final String productName;
  final String productType;
  final String productDescription;
  final double productBuyPrice;
  final double productSellPrice;
  final double productRating;
  final List<MediaModel> productImages;
  final List<MediaModel> productShorts;

  ProductModel({
    required this.categoryName,
    required this.categoryID,
    required this.supplierID,
    required this.productID,
    required this.productName,
    required this.productType,
    required this.productDescription,
    required this.productBuyPrice,
    required this.productSellPrice,
    required this.productRating,
    required this.productImages,
    required this.productShorts,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      supplierID: json['supplierID'],
      productID: json['productID'],
      productName: json['productName'],
      productType: json['productType'],
      productDescription: json['productDescription'],
      productBuyPrice: (json['productBuyPrice'] as num).toDouble(),
      productSellPrice: (json['productSellPrice'] as num).toDouble(),
      productRating: (json['productRating'] as num).toDouble(),
      productImages: (json['productImages'] as List<dynamic>).map((e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList().cast<MediaModel>(),
      productShorts: (json['productShorts'] as List<dynamic>).map((e) => MediaModel.fromJson(e as Map<String, dynamic>)).toList().cast<MediaModel>(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'categoryName': categoryName,
      'supplierID': supplierID,
      'productID': productID,
      'productName': productName,
      'productType': productType,
      'productDescription': productDescription,
      'productBuyPrice': productBuyPrice,
      'productSellPrice': productSellPrice,
      'productRating': productRating,
      'productImages': productImages.map((e) => e.toJson()).toList(),
      'productShorts': productShorts.map((e) => e.toJson()).toList(),
    };
  }
}

class MediaModel {
  final Uint8List bytes;
  final String ext;
  final String name;
  final String path;
  final String type;

  MediaModel({
    required this.bytes,
    required this.ext,
    required this.name,
    required this.path,
    required this.type,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      bytes: base64Decode(json['bytes']),
      ext: json['ext'],
      name: json['name'],
      path: json['path'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bytes': base64Encode(bytes),
      'ext': ext,
      'name': name,
      'path': path,
      'type': type,
    };
  }
}
