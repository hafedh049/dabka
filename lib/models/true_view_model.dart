import 'package:dabka/models/product_model.dart';

class TrueViewModel {
  final String categoryID;
  final String category;

  final MediaModel reelUrl;
  final int reelDuration;
  final String reelID;
  final String userID;
  final String productID;
  final String userName;
  final int reelViews;

  TrueViewModel({
    required this.categoryID,
    required this.category,
    required this.reelUrl,
    required this.reelDuration,
    required this.reelID,
    required this.userID,
    required this.productID,
    required this.userName,
    required this.reelViews,
  });

  factory TrueViewModel.fromJson(Map<String, dynamic> json) {
    return TrueViewModel(
      categoryID: json['categoryID'] as String,
      category: json['category'] as String,
      reelUrl: MediaModel.fromJson(json['reelUrl'] as Map<String, dynamic>),
      reelDuration: json['reelDuration'] as int,
      reelID: json['reelID'] as String,
      userID: json['userID'] as String,
      productID: json['productID'] as String,
      userName: json['userName'] as String,
      reelViews: json['reelViews'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'category': category,
      'reelUrl': reelUrl.toJson(),
      'reelDuration': reelDuration,
      'reelID': reelID,
      'userID': userID,
      'productID': productID,
      'userName': userName,
      'reelViews': reelViews,
    };
  }
}
