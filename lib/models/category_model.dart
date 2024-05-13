class CategoryModel {
  final String categoryID;
  final String categoryName;
  final String categoryUrl;

  CategoryModel({
    required this.categoryID,
    required this.categoryName,
    required this.categoryUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      categoryUrl: json['categoryUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'categoryName': categoryName,
      'categoryUrl': categoryUrl,
    };
  }
}
