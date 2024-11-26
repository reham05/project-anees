import 'package:anees/screens/profile_screen.dart';
import 'package:anees/screens/room_chat_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthorsScreenState createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        toolbarHeight: 70.h,
        title: Column(
          children: [
            SizedBox(
              height: 4.h,
            ),
            Text(
              'Authors',
              style: GoogleFonts.aclonica(
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: cGreen4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Authors',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: cGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: cGreen),
                ),
                prefixIcon: const Icon(Icons.search, color: cGreen),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('userType', isEqualTo: 'Author')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: cGreen,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final authors = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  final filteredAuthors = authors.where((author) {
                    final fullName =
                        author['fullName'].toString().toLowerCase();
                    return fullName.contains(searchQuery);
                  }).toList();

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final author = filteredAuthors[index];
                      if (author['uid'] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: cGreen4,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipOval(
                                child: Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          author['profile_picture_url']),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      author['fullName'],
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RoomChatScreen(
                                                            fullName: author[
                                                                'fullName'],
                                                            userImage: author[
                                                                'profile_picture_url'],
                                                            uid: author[
                                                                'uid'])));
                                          },
                                          icon: Icon(
                                            Icons.message_rounded,
                                            size: 20.sp,
                                            color: Colors.black,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileScreen(
                                                    userId: author['uid'],
                                                    fromHome: false,
                                                  ),
                                                ));
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20.sp,
                                            color: Colors.black,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      final author = filteredAuthors[index];
                      if (author['uid'] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return const SizedBox.shrink();
                      }

                      return SizedBox(height: 12.h);
                    },
                    itemCount: filteredAuthors.length,
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
