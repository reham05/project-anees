// ignore_for_file: avoid_single_cascade_in_expression_statements, await_only_futures

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  addLike(
      {required Map postMap, required userFullName, required userImage}) async {
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
      if (FirebaseAuth.instance.currentUser!.uid != postMap['uid']) {
        final notificationId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("activitesNotifications")
            .doc(postMap['uid'])
            .collection("notifications")
            .doc(notificationId)
            .set({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'userImage': userImage,
          'fullName': userFullName,
          'postid': postMap['postid'],
          'notifiactionTitle': "liked your post",
          'date': Timestamp.now(),
          'newNotification': true,
          'notificationId': notificationId
        });
      }
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

  deleteBooks({required QueryDocumentSnapshot<Object?> bookMap}) async {
    if (FirebaseAuth.instance.currentUser!.uid == bookMap['authorid']) {
      FirebaseFirestore.instance
          .collection('books')
          .doc(bookMap['bookid'])
          .delete();
    }
  }

  addComment({
    required comment,
    required userimage,
    required uid,
    required postid,
    required fullName,
    required postUserId,
  }) async {
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
          'postUserId': postUserId,
          'date': Timestamp.now()
        });
      if (FirebaseAuth.instance.currentUser!.uid != postUserId) {
        final notificationId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("activitesNotifications")
            .doc(postUserId)
            .collection("notifications")
            .doc(notificationId)
            .set({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'userImage': userimage,
          'fullName': fullName,
          'postid': postid,
          'notifiactionTitle': "commented on your post",
          'date': Timestamp.now(),
          'newNotification': true,
          'notificationId': notificationId
        });
      }
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

  followUser({required userId, required userName, required userImage}) async {
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

    final notificationId = const Uuid().v4();
    await FirebaseFirestore.instance
        .collection("activitesNotifications")
        .doc(userId)
        .collection("notifications")
        .doc(notificationId)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'userImage': userImage,
      'fullName': userName,
      'notifiactionTitle': "started following you",
      'date': Timestamp.now(),
      'newNotification': true,
      'notificationId': notificationId
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

  addFeedBacks(
      {required feedback,
      required userimage,
      required uid,
      required bookid,
      required fullName,
      required bookAuthorId,
      required book}) async {
    try {
      // ignore: prefer_const_constructors
      final feedbackid = Uuid().v4();
      await FirebaseFirestore.instance.collection('books').doc(bookid)
        ..collection('feedbacks').doc(feedbackid).set({
          'fullName': fullName,
          'feedback': feedback,
          'userImage': userimage,
          'bookid': bookid,
          'feedbackid': feedbackid,
          'uid': uid,
          'bookAuthorId': bookAuthorId,
          'date': Timestamp.now(),
        });
      if (FirebaseAuth.instance.currentUser!.uid != bookAuthorId) {
        final notificationId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("activitesNotifications")
            .doc(bookAuthorId)
            .collection("notifications")
            .doc(notificationId)
            .set({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'userImage': userimage,
          'fullName': fullName,
          'bookid': bookid,
          'notifiactionTitle': "gave feedback on your book",
          'date': Timestamp.now(),
          'newNotification': true,
          'notificationId': notificationId,
          'book': book
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
