// ignore_for_file: avoid_single_cascade_in_expression_statements, await_only_futures

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  addLike({required Map postMap}) async {
    if (postMap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postMap['postid'])
          .update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postMap['postid'])
          .update({
        'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    }
  }

  deletePosts({required Map postMap}) async {
    if (FirebaseAuth.instance.currentUser!.uid == postMap['uid']) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postMap['postid'])
          .delete();
    }
  }

  addComment(
      {required comment,
      required userimage,
      required uid,
      required postid,
      required fullName}) async {
    try {
      // ignore: prefer_const_constructors
      final commentid = Uuid().v4();
      await FirebaseFirestore.instance.collection('posts').doc(postid)
        ..collection('comments').doc(commentid).set({
          'fullName': fullName,
          'comment': comment,
          'userImage': userimage,
          'postid': postid,
          'commentid': commentid,
          'uid': uid,
          'date': Timestamp.now()
        });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  removeComment({required Map commentMap}) async {
    if (FirebaseAuth.instance.currentUser!.uid == commentMap['uid']) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(commentMap['postid'])
        ..collection('comments').doc(commentMap['commentid']).delete();
    }
  }

  followUser({required userId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'following': FieldValue.arrayUnion([userId])
    });
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'followers':
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  unfollowUser({required userId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'following': FieldValue.arrayRemove([userId])
    });
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'followers':
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
  }
}
