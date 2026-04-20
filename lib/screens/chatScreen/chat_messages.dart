import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chatScreen/chat_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticateduser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet"));
        }

        if (chatSnapshots.hasError) {
          return Center(child: Text("Something went wrong..."));
        }

        final messages = chatSnapshots.data!.docs;
        // print(messages);

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final chatMessage = messages[index].data();
            // print("chat message is $chatMessage");
            final nextChatMessage = index + 1 < messages.length
                ? messages[index + 1].data()
                : null;
            final currentUserID = chatMessage["userId"];
            final nextUserID = nextChatMessage != null
                ? nextChatMessage["userId"]
                : null;
            // final currentUserID = chatMessage["userImage"];
            final nextUserIsSame = nextUserID == currentUserID;
            final isMe = currentUserID == authenticateduser.uid;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage["text"],
                isMe: isMe,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage["userImage"],
                username: chatMessage["username"],
                message: chatMessage["text"],
                isMe: isMe,
              );
            }
          },
        );
      },
    );
  }
}


// Center(child: Text("No messages yet"))