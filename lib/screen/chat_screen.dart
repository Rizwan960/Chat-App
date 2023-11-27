import 'package:chat_app/widgets/auth/chat/messages.dart';
import 'package:chat_app/widgets/auth/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance.requestPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat App'),
        actions: <Widget>[
          DropdownButton(
            onChanged: (value) => {
              if (value == 'Logout') {FirebaseAuth.instance.signOut()}
            },
            icon: const Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: 'Logout',
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.exit_to_app),
                    Text("Logout"),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: const <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage()
          ],
        ),
      ),
    );
  }
}
