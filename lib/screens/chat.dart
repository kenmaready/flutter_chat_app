import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../widgets/new_message_input.dart';
import '../widgets/messages_list.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("background message received: ${message.data.toString()}");
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _messageListScrollController = ScrollController();

  void _scrollDown() {
    _messageListScrollController.animateTo(
        _messageListScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print('message: ${message.data.toString()}');
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('message on opening: ${message.data.toString()}');
      return;
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
              underline: Container(),
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
      body: Column(children: [
        Expanded(child: MessagesList(controller: _messageListScrollController)),
        NewMessageInput()
      ]),
    );
  }
}
