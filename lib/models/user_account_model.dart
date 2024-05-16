class UserModel {
  final String userID;
  final String username;
  final String categoryName;
  final String categoryID;
  final String userAvatar;
  final List<String> userType;
  final String userDescription;
  final double userRating;
  final int followers;

  UserModel({
    required this.categoryName,
    required this.categoryID,
    required this.userID,
    required this.username,
    required this.userAvatar,
    required this.userType,
    required this.userDescription,
    required this.userRating,
    required this.followers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
      userID: json['userID'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      userType: List<String>.from(json['userType'] ?? <String>[]),
      userDescription: json['userDescription'],
      userRating: json['userRating'],
      followers: json['followers'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'categoryName': categoryName,
      'userID': userID,
      'username': username,
      'userAvatar': userAvatar,
      'userType': userType,
      'userDescription': userDescription,
      'userRating': userRating,
      'followers': followers,
    };
  }
}
