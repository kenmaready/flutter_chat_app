import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../widgets/new_message_input.dart';
import '../widgets/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print('message: $message');
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('message on opening: $message');
      return;
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    print('chat screen called: building...');
    final collection = FirebaseFirestore.instance.collection('chat/');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
        actions: [
          DropdownButton(
              icon: const Icon(Icons.more_vert),
              onChanged: (identifier) {
                if (identifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
              items: [
                DropdownMenuItem(
                  child: Container(
                      child: Row(children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout')
                  ])),
                  value: 'logout',
                ),
              ])
        ],
      ),
      body: Column(
          children: [Expanded(child: MessagesList()), NewMessageInput()]),
    );
  }
}
