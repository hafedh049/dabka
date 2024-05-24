class ReviewModel {
  final String reviewID;
  final String applierName;
  final String productID;
  final double rating;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.timestamp,
    required this.reviewID,
    required this.applierName,
    required this.productID,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      timestamp: json['timestamp'].toDate(),
      reviewID: json['reviewID'],
      applierName: json['applierName'],
      productID: json['productID'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'timestamp': timestamp,
      'reviewID': reviewID,
      'applierName': applierName,
      'productID': productID,
      'rating': rating,
      'comment': comment,
    };
  }
}
