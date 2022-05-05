import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//
import 'message_bubble.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collection =
        FirebaseFirestore.instance.collection('chat/').orderBy('createdAt');

    return StreamBuilder(
        stream: collection.snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = stream.data?.docs;
          return ListView.builder(
              itemBuilder: (ctx, index) => MessageBubble(message: docs![index]),
              itemCount: stream.data?.docs.length);
        });
  }
}
