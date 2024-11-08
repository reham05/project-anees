import 'dart:convert';
import 'dart:developer';

import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    getUserImage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        messages.add({"text": "Hi, How can I help you?", "isUser": false});
      });
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
        Uri.parse('https://work.pythonanywhere.com/chat'),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: cGreen,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: cWhite,
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10.0, left: 10.0, top: 15, bottom: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: SafeArea(
                            child: SizedBox(
                              height: 15.h,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
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
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: cGreen2,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      // vertical: 12,
                                      horizontal: 12,
                                    ),
                                    hintText: 'Type your message here...',
                                    hintStyle: TextStyle(
                                        color: Colors.black45,
                                        fontStyle: FontStyle.italic),
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
                                icon:
                                    const Icon(Icons.send, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -120.h,
                    // left: -5.w,
                    child: SvgPicture.asset(
                      'assets/images/Ellipse-author-profile.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                      top: 25.h,
                      left: 20.w,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ))),
                  Positioned(
                    top: 35.h,
                    left: 110.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to",
                          style: GoogleFonts.aclonica(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
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
    );
  }
}
