class TrueViewModel {
  final String categoryID;
  final String category;
  final String package;
  final double price;
  final String reelUrl;
  final int reelDuration;
  final String reelID;
  final String userID;
  final int reelViews;

  TrueViewModel({
    required this.categoryID,
    required this.category,
    required this.package,
    required this.price,
    required this.reelUrl,
    required this.reelDuration,
    required this.reelID,
    required this.userID,
    required this.reelViews,
  });

  factory TrueViewModel.fromJson(Map<String, dynamic> json) {
    return TrueViewModel(
      categoryID: json['categoryID'],
      category: json['category'],
      package: json['package'],
      price: json['price'],
      reelUrl: json['reelUrl'],
      reelDuration: json['reelDuration'],
      reelID: json['reelID'],
      userID: json['userID'],
      reelViews: json['reelViews'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'category': category,
      'package': package,
      'price': price,
      'reelUrl': reelUrl,
      'reelDuration': reelDuration,
      'reelID': reelID,
      'userID': userID,
      'reelViews': reelViews,
    };
  }
}
