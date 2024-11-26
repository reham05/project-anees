import 'dart:convert';
import 'dart:developer';

import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'widgets/chat_bubble.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  String? userImage;
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool showList = true;

  List<String> questions = [
    "Writing tips",
    "Self-publishing",
    "Publishing house proposal",
    "Open publishing houses in Saudi Arabia?",
    "Promote book",
    "Editing services",
    "Book cover design",
    "Book pricing",
    "Book trailer",
    "Copyright registration",
    "Publishing timeline",
    "Publishing license issuance",
    "Registration of Saudi Authors Pavilion"
  ];
  @override
  void initState() {
    super.initState();
    getUserImage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        messages.add({
          "text":
              "Hey there! I'm Anees, your personal book buddy. How can I assist you today?",
          "isUser": false
        });
      });
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          showList = true;
          log(showList.toString());
        });
      } else {
        setState(() {
          showList = false;
          log(showList.toString());
        });
      }
    });
  }

  Future<void> getUserImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var userData = snapshot.data();

      setState(() {
        userImage = userData!['profile_picture_url'];
        isLoading = false;
      });
    } on Exception catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
        userImage = "not-image";
      });
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('https://aneeschatbot.pythonanywhere.com/chat'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"message": message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          messages.add({"text": message, "isUser": true});
          messages.add({"text": responseData["response"], "isUser": false});
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      } else {
        setState(() {
          messages.add({"text": message, "isUser": true});
          messages.add({
            "text": "Error: Unable to connect to the server.",
            "isUser": false
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"text": message, "isUser": true});
        messages.add({
          "text": "Error: Unable to connect to the server.",
          "isUser": false
        });
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    _controller.clear();
  }

  void _onWillPop() async {
    if (messages.length > 1) {
      bool btnLoading = false;
      double userRating = 0;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AbsorbPointer(
            absorbing: btnLoading,
            child: AlertDialog(
              backgroundColor: cGreen,
              title: const Text("Rate Anees Bot",
                  style: TextStyle(color: cWhite, fontSize: 22)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "How satisfied are you with anees bot performance? Your feedback helps us improve!",
                    style: TextStyle(fontSize: 14, color: cWhite),
                  ),
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 10.sp,
                      color: Colors.amber,
                    ),
                    unratedColor: Colors.grey.shade300,
                    itemSize: 35.sp,
                    onRatingUpdate: (rating) {
                      userRating = rating;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (btnLoading == false) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: cWhite),
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(cGreen4)),
                  onPressed: () async {
                    if (btnLoading == false) {
                      btnLoading = true;
                      log("User Rating: $userRating");
                      final feedbackid = const Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection("anessbot_feedbacks")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("feedbacks")
                          .doc(feedbackid)
                          .set({
                        'chat': messages,
                        'userRating': userRating,
                      });

                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: cGreen),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
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
          _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: cGreen,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: cWhite,
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 210.h,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Positioned(
                            top: -20.h,
                            left: -15.w,
                            child: SvgPicture.asset(
                              'assets/images/Ellipse-author-profile.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      onPressed: _onWillPop,
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "Welcome to",
                                style: GoogleFonts.aclonica(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                "Anees-bot",
                                style: GoogleFonts.aclonica(
                                    color: Colors.black,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40.h,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      String userInput = questions[index];
                                      if (userInput.isNotEmpty) {
                                        sendMessage(userInput);
                                      }
                                    },
                                    child: Container(
                                        height: 25.h,
                                        // width: 30.w,
                                        decoration: BoxDecoration(
                                            color: cGreen2,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            questions[index],
                                            style: GoogleFonts.inter(
                                              color: cWhite,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                        )),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 5.w,
                                  );
                                },
                                itemCount: questions.length),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubble(
                                text: messages[index]["text"],
                                isUser: messages[index]["isUser"],
                                userImage: userImage!,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            height: 50.h,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: cGreen2,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _controller,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNode);
                                    },
                                    focusNode: _focusNode,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        // vertical: 12,
                                        horizontal: 12,
                                      ),
                                      hintText: 'Type your message here...',
                                      hintStyle: TextStyle(
                                          color: Colors.black45,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15.sp),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    String userInput = _controller.text;
                                    if (userInput.isNotEmpty) {
                                      sendMessage(userInput);
                                    }
                                  },
                                  icon: const Icon(Icons.send,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
