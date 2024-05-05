class TrueViewModel {
  final String category;
  final String package;
  final double price;
  final String reelUrl;
  final String reelID;
  final String userID;
  final int reelViews;

  TrueViewModel({
    required this.userID,
    required this.category,
    required this.package,
    required this.price,
    required this.reelUrl,
    required this.reelID,
    required this.reelViews,
  });

  factory TrueViewModel.fromJson(Map<String, dynamic> json) {
    return TrueViewModel(
      userID: json['userID'],
      category: json['category'],
      package: json['package'],
      price: json['price'].toDouble(),
      reelUrl: json['reelUrl'],
      reelID: json['reelID'],
      reelViews: json['reelViews'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'package': package,
        'userID': userID,
        'category': category,
        'price': price,
        'reelUrl': reelUrl,
        'reelID': reelID,
        'reelViews': reelViews,
      };
}
