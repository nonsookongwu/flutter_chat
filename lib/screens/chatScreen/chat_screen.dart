import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chatScreen/chat_messages.dart';
import 'package:flutter_chat/screens/chatScreen/new_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

void setUpNotifications() async{
final fcm = FirebaseMessaging.instance;
await fcm.requestPermission();
// final token = await fcm.getToken();
// print("token is $token");
fcm.subscribeToTopic("smile");
}

@override
  void initState() {
    super.initState();
    setUpNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessages(),
        ],
      ),
    );
  }
}
