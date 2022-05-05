import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'dart:convert';

class MessageBubble extends StatelessWidget {
  final DocumentSnapshot message;
  const MessageBubble({Key? key, required this.message}) : super(key: key);

  bool get _isMine {
    return message.get('userId') == FirebaseAuth.instance.currentUser?.uid;
  }

  String get _username {
    return message.get('username');
  }

  String get _userImage {
    return message.get('userImage');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Bubble(
            key: ValueKey(message.id),
            margin: const BubbleEdges.symmetric(vertical: 6, horizontal: 12),
            padding: const BubbleEdges.symmetric(vertical: 8, horizontal: 24),
            alignment: _isMine ? Alignment.bottomRight : Alignment.bottomLeft,
            nip: _isMine ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            elevation: 10,
            color: _isMine ? Colors.blue.shade400 : Colors.grey.shade300,
            child: Column(children: [
              Text(message.get('text'),
                  style: TextStyle(
                      color: _isMine ? Colors.white : Colors.black87)),
              Text(
                _username,
                style: TextStyle(
                    color: _isMine ? Colors.white : Colors.black87,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              )
            ])),
        Positioned(
            top: -10,
            right: _isMine ? 0 : deviceSize.width * .9,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(_userImage),
            ))
      ],
      clipBehavior: Clip.none,
    );
  }
}
