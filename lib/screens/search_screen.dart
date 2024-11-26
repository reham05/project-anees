// ignore_for_file: library_private_types_in_public_api, unnecessary_cast

import 'dart:developer';

import 'package:anees/screens/home.dart';
import 'package:anees/screens/profile_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_book_screen.dart';

class MultiCollectionSearchPage extends StatefulWidget {
  const MultiCollectionSearchPage({super.key});

  @override
  _MultiCollectionSearchPageState createState() =>
      _MultiCollectionSearchPageState();
}

class _MultiCollectionSearchPageState extends State<MultiCollectionSearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  List<Map<String, dynamic>> recentSearches = [];
  int searchCount = 0;
  int counterSearch = 0;
  bool firstOpen = true;
  @override
  void initState() {
    super.initState();

    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    try {
      var recentSearchSnapshot = await FirebaseFirestore.instance
          .collection('recent_searches')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('saved_searches')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      List<Map<String, dynamic>> recentSearchList = [];

      for (var doc in recentSearchSnapshot.docs) {
        recentSearchList.add(doc.data() as Map<String, dynamic>);
      }

      setState(() {
        recentSearches = recentSearchList;
      });
    } catch (e) {
      log("Error loading recent searches: $e");
    }
  }

  Future<void> searchInBooksAndUsers(String query, String category) async {
    setState(() {
      isLoading = true;
      searchResults.clear();
      firstOpen = false;
      counterSearch = 0;
    });

    try {
      QuerySnapshot booksSnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('title', isEqualTo: query)
          .get();
      counterSearch += booksSnapshot.docs.length;
      for (var doc in booksSnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;

        await _saveSearchQueryWithBookData(query, category, bookData);

        searchResults.add({
          ...bookData,
          'type': 'book',
        });
      }

      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isEqualTo: query)
          .get();
      counterSearch += usersSnapshot.docs.length;
      for (var doc in usersSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        searchResults.add({
          ...userData,
          'type': 'user',
        });
      }
    } catch (e) {
      log("Error searching: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveSearchQueryWithBookData(
      String query, String category, Map<String, dynamic> bookData) async {
    final userDoc = FirebaseFirestore.instance
        .collection('recent_searches')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await userDoc.collection('saved_searches').add({
      'query': query,
      'typeSearch': "book",
      'category': category,
      'timestamp': FieldValue.serverTimestamp(),
      'bookData': bookData,
    });

    var recentSearchSnapshot =
        await userDoc.collection('saved_searches').orderBy('timestamp').get();

    if (recentSearchSnapshot.docs.length > 2) {
      await _clearRecentSearches();
    }

    _loadRecentSearches();
  }

  Future<void> _clearRecentSearches() async {
    final userDoc = FirebaseFirestore.instance
        .collection('recent_searches')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var savedSearches = await userDoc.collection('saved_searches').get();
    List<String> categories = savedSearches.docs
        .map((doc) => doc.data()['bookData']['category'] as String)
        .toList();

    log(categories.toString());
    final userRealtimeRef = FirebaseDatabase.instance
        .ref()
        .child('users_interests')
        .child(FirebaseAuth.instance.currentUser!.uid);

    await userRealtimeRef.update({'interests': categories});

    for (var doc in savedSearches.docs) {
      await doc.reference.delete();
    }

    setState(() {
      recentSearches = [];
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        {
          if (didPop) {
            return;
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ));
        }
      },
      child: Scaffold(
        backgroundColor: cWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ));
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.inter(
                            color: cGreen,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: 'Search for books, Author, Reader..',
                          labelStyle: GoogleFonts.inter(
                              color: Colors.black, fontSize: 13.sp),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: const BorderSide(
                              color: cGrey,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: const BorderSide(
                              color: cGrey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: const BorderSide(
                              color: cGreen,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onSubmitted: (query) {
                          if (query.isNotEmpty) {
                            searchInBooksAndUsers(query.trim(), 'all');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 20),
                // Row(
                //   children: [
                //     Text(
                //       'Recent Searches:',
                //       style: GoogleFonts.inter(
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.bold,
                //           color: cGreen),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10),
                // Row(
                //   children: recentSearches.map((search) {
                //     return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         onTap: () {},
                //         child: Container(
                //           width: 90.w,
                //           decoration: BoxDecoration(
                //               color: cGreen4,
                //               borderRadius: BorderRadius.circular(20)),
                //           child: Column(
                //             children: [
                //               SizedBox(height: 5.h),
                //               Padding(
                //                 padding: const EdgeInsets.all(5.0),
                //                 child: Container(
                //                   height: 90.h,
                //                   width: 60.w,
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(10),
                //                       image: DecorationImage(
                //                         image: NetworkImage(
                //                             search['bookData']['urlBookCover']),
                //                         fit: BoxFit.fill,
                //                       )),
                //                 ),
                //               ),
                //               Text(
                //                 search['bookData']['title'],
                //                 style: GoogleFonts.inter(
                //                     fontWeight: FontWeight.bold, fontSize: 8.sp),
                //                 overflow: TextOverflow.ellipsis,
                //                 maxLines: 1,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   }).toList(),
                // ),
                SizedBox(height: 10.h),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: cGreen,
                      ))
                    : counterSearch == 0 && !firstOpen
                        ? const Expanded(
                            child: Center(
                                child: Text(
                                    "No authors, readers, or books found.")),
                          )
                        : Expanded(
                            child: searchResults.isNotEmpty
                                ? ListView.builder(
                                    itemCount: searchResults.length,
                                    itemBuilder: (context, index) {
                                      var result = searchResults[index];
                                      if (result['type'] == 'book') {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AboutBookScreen(
                                                    book: searchResults[index],
                                                  ),
                                                ));
                                          },
                                          child: Card(
                                            color: cGreen4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 90.h,
                                                        width: 60.w,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      searchResults[
                                                                              index]
                                                                          [
                                                                          'urlBookCover']),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Title:",
                                                            style: GoogleFonts
                                                                .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12.sp),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            searchResults[index]
                                                                ['title'],
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize:
                                                                    11.sp),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            "Author:",
                                                            style: GoogleFonts
                                                                .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12.sp),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            searchResults[index]
                                                                ['authorName'],
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize:
                                                                    10.sp),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            "Category:",
                                                            style: GoogleFonts
                                                                .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12.sp),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            " ${searchResults[index]['category']}",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize:
                                                                    10.sp),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AboutBookScreen(
                                                                  book:
                                                                      searchResults[
                                                                          index],
                                                                ),
                                                              ));
                                                        },
                                                        icon: const Icon(Icons
                                                            .arrow_forward_ios),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (result['type'] == 'user') {
                                        return Card(
                                          color: cGreen4,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  result[
                                                      'profile_picture_url']),
                                            ),
                                            title: Text(
                                              result['fullName'],
                                              style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.sp),
                                            ),
                                            subtitle: Text(
                                              result['userType'],
                                              style: GoogleFonts.inter(
                                                  color: Colors.grey.shade700),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileScreen(
                                                                userId: result[
                                                                    'uid'],
                                                                fromHome:
                                                                    false),
                                                      ));
                                                },
                                                icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black,
                                                  size: 18.sp,
                                                )),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  )
                                : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
