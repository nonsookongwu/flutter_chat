import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() {
    return _NewMessagesState();
  }
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); 
    _messageController.clear();//closes any keyboard that is open

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection("chat").add({
      "text": enteredMessage,
      "createdAt": Timestamp.now(),
      'userId': user.uid,
      "username": userData.data()!["userName"],
      'userImage': userData.data()!["imageUrl"],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5, bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(label: Text("Send a message ...")),
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            color: Theme.of(context).colorScheme.primary,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
