import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String userImage;

  const ChatBubble(
      {super.key,
      required this.text,
      required this.isUser,
      required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser)
              const CircleAvatar(
                backgroundColor: cWhite,
                backgroundImage: AssetImage('assets/images/chatbot.gif'),
                radius: 15,
              ),
            if (!isUser) const SizedBox(width: 10),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isUser ? cGreen2 : Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft:
                        isUser ? const Radius.circular(15) : Radius.zero,
                    bottomRight:
                        isUser ? Radius.zero : const Radius.circular(15),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (isUser) const SizedBox(width: 10),
            if (isUser)
              CircleAvatar(
                backgroundImage: NetworkImage(userImage),
                radius: 15,
              ),
          ],
        ),
      ),
    );
  }
}
