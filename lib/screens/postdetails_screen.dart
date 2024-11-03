import 'dart:developer';
import 'package:anees/Firebase/firestore.dart';
import 'package:anees/screens/comment_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Map<String, dynamic>? postDetails;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
    _fetchCommentsCount();
  }

  Future<void> _fetchPostDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          postDetails = docSnapshot.data();
        });
      } else {
        log('Post not found');
      }
    } catch (e) {
      log('Error fetching post details: $e');
    }
  }

  Future<void> _fetchCommentsCount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .get();
      setState(() {
        commentCount = snapshot.docs.length;
        log(commentCount.toString());
      });
    } catch (e) {
      log('Error fetching comments count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cGreen4,
      appBar: AppBar(
        backgroundColor: cGreen4,
        title: Text("Post Details", style: GoogleFonts.aclonica()),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: postDetails == null
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundImage:
                            NetworkImage(postDetails!['userImage'] ?? ''),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                postDetails!['fullName'] ?? '',
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(postDetails!['createdAt'],
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(postDetails!['des'] ?? '',
                      style: GoogleFonts.inter(fontSize: 14.sp)),
                  SizedBox(height: 10.h),
                  if (postDetails!['imagepost'] != '')
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(postDetails!['imagepost']),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  SizedBox(height: 10.h),
                  Divider(color: Colors.grey.shade400),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Comments ($commentCount)',
                          style: GoogleFonts.inter(fontSize: 16.sp)),
                      IconButton(
                        icon: const Icon(Icons.add_comment_rounded,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        postId: postDetails!['postid'],
                                      )));
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postId)
                          .collection('comments')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No comments yet"));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> commentData =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    commentData['userImage'] ?? ''),
                              ),
                              title: Text(commentData['fullName']),
                              subtitle: Text(commentData['comment']),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
