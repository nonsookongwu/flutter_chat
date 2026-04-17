import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Text(messages[index]["text"]);
          },
        );
      },
    );
  }
}


// Center(child: Text("No messages yet"))