class ReviewModel {
  final String reviewID;
  final String supplierID;
  final String clientID;
  final String productID;
  final double rating;
  final String comment;

  ReviewModel({
    required this.reviewID,
    required this.supplierID,
    required this.clientID,
    required this.productID,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewID: json['reviewID'],
      supplierID: json['supplierID'],
      clientID: json['clientID'],
      productID: json['productID'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reviewID': reviewID,
      'supplierID': supplierID,
      'clientID': clientID,
      'productID': productID,
      'rating': rating,
      'comment': comment,
    };
  }
}
