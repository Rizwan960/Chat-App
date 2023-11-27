import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var name;
  var _enteredMessage = '';
  final _controller = TextEditingController();
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Users');
    collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      name = value.data();
    });
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'SendTime': Timestamp.now(),
        'UserId': FirebaseAuth.instance.currentUser!.uid,
        // // 'UserName': name['name'],
        // 'UserImage': name['imageUrl']
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(9),
      child: Row(children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Send Message..'),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          ),
        ),
        IconButton(
          onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          icon: const Icon(Icons.send),
          color: Theme.of(context).primaryColor,
        )
      ]),
    );
  }
}
