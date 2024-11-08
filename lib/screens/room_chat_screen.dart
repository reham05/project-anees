import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../utils/colors.dart';

class RoomChatScreen extends StatefulWidget {
  const RoomChatScreen({
    super.key,
    required this.fullName,
    required this.userImage,
    required this.uid,
    this.readmessage = false,
  });
  final String fullName;
  final String userImage;
  final String uid;
  final bool readmessage;
  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  TextEditingController messageController = TextEditingController();

  String chatRoomId() {
    List users = [FirebaseAuth.instance.currentUser!.uid, widget.uid];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  Future<void> readMessage({required messageid}) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId())
        .collection('messages')
        .doc(messageid)
        .update({
      'readmessage': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cGreen2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(widget.userImage),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.fullName,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 25.w,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatRoomId())
                      .collection('messages')
                      .orderBy('date', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        color: cGreen,
                      )));
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error"));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "Say Hello 👋",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> messageMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        String currentId =
                            FirebaseAuth.instance.currentUser!.uid;
                        String senderid = messageMap['senderid'];
                        String messageid = messageMap['messageId'];
                        if (senderid !=
                            FirebaseAuth.instance.currentUser!.uid) {
                          readMessage(messageid: messageid);
                        }
                        return Align(
                          alignment: senderid != currentId
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: senderid == currentId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: senderid == currentId
                                        ? cGreen2
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      messageMap['message'],
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat.jm()
                                    .format(messageMap['date'].toDate()),
                                style: GoogleFonts.inter(fontSize: 13.sp),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: messageController,
                cursorColor: cGreen,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (messageController.text != '') {
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        final userData = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .get();
                        await FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatRoomId())
                            .set({
                          'senderName': userData['fullName'],
                          'senderImage': userData['profile_picture_url'],
                          'senderId': uid,
                          'reciverName': widget.fullName,
                          'reciverImage': widget.userImage,
                          'reciverId': widget.uid,
                          'participants': [uid, widget.uid],
                          'chatroomid': chatRoomId(),
                          'date': Timestamp.now(),
                        });
                        final uuid = Uuid().v4();
                        await FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatRoomId())
                            .collection('messages')
                            .doc(uuid)
                            .set({
                          'message': messageController.text,
                          'readmessage': false,
                          'senderid': uid,
                          'date': Timestamp.now(),
                          'messageId': uuid,
                        });
                        setState(() {
                          messageController.text = '';
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: cGreen,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: cGreen)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: cGreen2)),
                  hintText: 'Type here',
                  hintStyle: GoogleFonts.inter(fontSize: 14.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
