class ProductModel {
  final String categoryID;
  final String supplierID;
  final String productID;
  final String productName;
  final String productType;
  final String productDescription;
  final double productBuyPrice;
  final double productSellPrice;
  final double productRating;
  final List<String> productImages;
  final List<String> productShorts;

  ProductModel({
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
      supplierID: json['supplierID'],
      productID: json['productID'],
      productName: json['productName'],
      productType: json['productType'],
      productDescription: json['productDescription'],
      productBuyPrice: json['productBuyPrice'],
      productSellPrice: json['productSellPrice'],
      productRating: json['productRating'],
      productImages: List<String>.from(json['productImages'] ?? []),
      productShorts: List<String>.from(json['productShorts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'supplierID': supplierID,
      'productID': productID,
      'productName': productName,
      'productType': productType,
      'productDescription': productDescription,
      'productBuyPrice': productBuyPrice,
      'productSellPrice': productSellPrice,
      'productRating': productRating,
      'productImages': productImages,
      'productShorts': productShorts,
    };
  }
}
