import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final bool isNewUser =
            userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          log("New user signed up: ${user.displayName}");
          String uid = user.uid;

          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'uid': uid,
            'fullName': user.displayName,
            'email': user.email,
            'createdAt': Timestamp.now(),
            'userType': "",
            'profile_picture_url':
                "https://firebasestorage.googleapis.com/v0/b/anees-a8319.appspot.com/o/iconPerson.png?alt=media&token=ed7f9966-6e55-42a9-9719-68f1fcb85451",
            "completedPickInterest": false,
            'city': "",
            'region': "",
            'followers': [],
            'following': [],
          });
        } else {
          log("Existing user signed in: ${user.displayName}");
        }

        return {
          'user': user,
          'isNewUser': isNewUser,
        };
      } else {
        log("User object is null");
        return null;
      }
    } catch (e) {
      log("Error is: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> signInWithTwitter() async {
    final TwitterLogin twitterLogin = TwitterLogin(
      apiKey: 'Vw882P62UJfduAJyTlWt4rllA',
      apiSecretKey: 'ZuxBaZlBcgjgJdR5oiJypwr8uJsSEAdA072AafyVPhPpIAT9ul',
      redirectURI: 'com.example.anees://',
    );
    try {
      final authResult = await twitterLogin.login();
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final String? accessToken = authResult.authToken;
          final String? accessTokenSecret = authResult.authTokenSecret;

          if (accessToken != null && accessTokenSecret != null) {
            final AuthCredential credential = TwitterAuthProvider.credential(
              accessToken: accessToken,
              secret: accessTokenSecret,
            );

            final UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            final User? user = userCredential.user;

            if (user != null) {
              final bool isNewUser =
                  userCredential.additionalUserInfo?.isNewUser ?? false;

              if (isNewUser) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                  'uid': user.uid,
                  'fullName': user.displayName,
                  'email': user.email,
                  'createdAt': Timestamp.now(),
                  'userType': "",
                  'profile_picture_url':
                      "https://firebasestorage.googleapis.com/v0/b/anees-a8319.appspot.com/o/iconPerson.png?alt=media&token=ed7f9966-6e55-42a9-9719-68f1fcb85451",
                  'city': "",
                  'region': "",
                  "completedPickInterest": false,
                  'followers': [],
                  'following': [],
                });
              }

              return {
                'user': user,
                'isNewUser': isNewUser,
              };
            } else {
              log("User object is null");
              return null;
            }
          } else {
            log("Access token or secret is null");
            return null;
          }

        case TwitterLoginStatus.cancelledByUser:
          log("Login cancelled by user.");
          return null;

        case TwitterLoginStatus.error:
          log("Error logging in: ${authResult.errorMessage}");
          return null;

        default:
          log("Unhandled Twitter login status: ${authResult.status}");
          return null;
      }
    } catch (e) {
      log("Exception during Twitter login: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          await _googleSignIn.signOut();
        }
      }
      await FirebaseAuth.instance.signOut();
    }
  }
}
