import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String userType;
  final String userImage;
  final List followers;
  final List following;
  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.userType,
    required this.userImage,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> convertToMap() {
    return {
      'uid': userId,
      'fullName': fullName,
      'email': email,
      'userType': userType,
      'profile_picture_url': userImage,
      'followers': followers,
      'following': following,
    };
  }

  static convertSnapToModel(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        userId: snapshot['uid'],
        fullName: snapshot['fullName'],
        email: snapshot['email'],
        userType: snapshot['userType'],
        userImage: snapshot['profile_picture_url'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
