class UserModel {
  final String userID;
  final String username;
  final String userAvatar;
  final String userType;
  final String userDescription;
  final double userRating;
  final bool userState;
  final List<String> workingHours;
  final int profileView;
  final int followers;
  final int favorite;
  final String location;
  final List<String> paymentMethods;

  UserModel({
    required this.userID,
    required this.username,
    required this.userAvatar,
    required this.userType,
    required this.userDescription,
    required this.userRating,
    required this.userState,
    required this.workingHours,
    required this.profileView,
    required this.followers,
    required this.favorite,
    required this.location,
    required this.paymentMethods,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['userID'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      userType: json['userType'],
      userDescription: json['userDescription'],
      userRating: json['userRating'].toDouble(),
      userState: json['userState'],
      workingHours: List<String>.from(json['workingHours']),
      profileView: json['profileView'],
      followers: json['followers'],
      favorite: json['favorite'],
      location: json['location'],
      paymentMethods: List<String>.from(json['paymentMethods']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userID': userID,
        'username': username,
        'userAvatar': userAvatar,
        'userType': userType,
        'userDescription': userDescription,
        'userRating': userRating,
        'userState': userState,
        'workingHours': workingHours,
        'profileView': profileView,
        'followers': followers,
        'favorite': favorite,
        'location': location,
        'paymentMethods': paymentMethods,
      };
}
