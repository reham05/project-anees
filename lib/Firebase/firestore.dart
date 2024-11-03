// ignore_for_file: avoid_single_cascade_in_expression_statements

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
      required uuid,
      required postid,
      required fullName}) async {
    try {
      final commentid = Uuid().v4();
      await FirebaseFirestore.instance.collection('posts').doc(postid)
        ..collection('comments').doc(commentid).set({
          'fullName': fullName,
          'comment': comment,
          'userImage': userimage,
          'postid': postid,
          'commentid': commentid,
        });
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
