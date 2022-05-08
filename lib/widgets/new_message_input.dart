import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageInput extends StatefulWidget {
  const NewMessageInput({Key? key}) : super(key: key);

  @override
  State<NewMessageInput> createState() => _NewMessageInputState();
}

class _NewMessageInputState extends State<NewMessageInput> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'userId': userId,
      'username': user.get('username'),
      'userImage': user.get('imageUrl'),
      'createdAt': Timestamp.now()
    });
    _enteredMessage = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration:
                    const InputDecoration(labelText: 'Send a message...'),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            )
          ],
        ));
  }
}
