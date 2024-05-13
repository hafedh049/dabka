class UserModel {
  final String userID;
  final String username;
  final String userAvatar;
  final List<String> userType;
  final String userDescription;
  final double userRating;
  final int profileView;
  final int followers;

  UserModel({
    required this.userID,
    required this.username,
    required this.userAvatar,
    required this.userType,
    required this.userDescription,
    required this.userRating,
    required this.profileView,
    required this.followers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['userID'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      userType: List<String>.from(json['userType'] ?? <String>[]),
      userDescription: json['userDescription'],
      userRating: json['userRating'],
      profileView: json['profileView'],
      followers: json['followers'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userID': userID,
      'username': username,
      'userAvatar': userAvatar,
      'userType': userType,
      'userDescription': userDescription,
      'userRating': userRating,
      'profileView': profileView,
      'followers': followers,
    };
  }
}
