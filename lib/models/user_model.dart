// ignore_for_file: file_names

class UserModel {
  final String uId;
  final String username;
  final String email;
  final String userImg;
  final String userDeviceToken;
  final String country;
  final bool isAdmin;
  final bool isActive;
  final dynamic createdOn;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.userImg,
    required this.userDeviceToken,
    required this.country,
    required this.isAdmin,
    required this.isActive,
    required this.createdOn,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'country': country,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdOn': createdOn,
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      userImg: json['userImg'],
      userDeviceToken: json['userDeviceToken'],
      country: json['country'],
      isAdmin: json['isAdmin'],
      isActive: json['isActive'],
      createdOn: json['createdOn'].toString(),
    );
  }
}
