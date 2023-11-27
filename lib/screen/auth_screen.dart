import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var url;
  final auth = FirebaseAuth.instance;
  void _submitForm(String email, String userName, String password, bool isLogin,
      File userImage) async {
    try {
      if (isLogin) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await auth
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password)
            .then(
          (value) async {
            final ref = FirebaseStorage.instance
                .ref()
                .child('User_Images')
                .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
            await ref.putFile(userImage);
            url = await ref.getDownloadURL();
          },
        ).then(
          (valuee) {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set(
              {
                'name': userName,
                'email': email,
                'imageUrl': url,
              },
            );
          },
        );
      }
    } on PlatformException catch (e) {
      var message = 'Error Occourd';
      if (e.message != null) {
        message = e.message.toString();
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submit: _submitForm),
    );
  }
}
