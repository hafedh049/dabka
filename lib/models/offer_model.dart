class OfferModel {
  final String offerID;
  final String categoryID;
  final String category; // Added this line
  final String username; // Added this line
  final String userID;
  final String offerName;
  final String offerType;
  final String offerImage;
  final double offerDiscount; // Added this line
  final DateTime timestamp;

  OfferModel({
    required this.offerID,
    required this.categoryID,
    required this.category, // Added this line
    required this.username, // Added this line
    required this.userID,
    required this.offerName,
    required this.offerType,
    required this.offerImage,
    required this.offerDiscount, // Added this line
    required this.timestamp,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      offerID: json['offerID'] as String,
      categoryID: json['categoryID'] as String,
      category: json['category'] as String, // Added this line
      username: json['username'] as String, // Added this line
      userID: json['userID'] as String,
      offerName: json['offerName'] as String,
      offerType: json['offerType'] as String,
      offerImage: json['offerImage'] as String,
      offerDiscount: (json['offerDiscount'] as num).toDouble(), // Added this line
      timestamp: json['timestamp'].toDate(), // Modified this line to parse timestamp from string
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'offerID': offerID,
      'categoryID': categoryID,
      'category': category, // Added this line
      'username': username, // Added this line
      'userID': userID,
      'offerName': offerName,
      'offerType': offerType,
      'offerImage': offerImage,
      'offerDiscount': offerDiscount, // Added this line
      'timestamp': timestamp, // Modified this line to convert timestamp to ISO 8601 string
    };
  }
}
