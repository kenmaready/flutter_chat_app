import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File? image, bool isLogin) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        // create user in the firebase auth system
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // upload user image to firebase and get path:
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user?.uid}.jpg');

        await ref.putFile(image as File);
        final imageUrl = await ref.getDownloadURL();

        // create user in firebase users collection:
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now()
        });
      }

      print("userCredential: ${userCredential.toString()}");
    } on FirebaseAuthException catch (err) {
      var message = err.message ??
          'An error occured when attempting to `${isLogin ? 'log' : 'sign'} user ${isLogin ? 'in' : 'up'}. Please check your credentials.';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } catch (err) {
      print("Error occurred in _submitAuthForm: ${err.toString()}");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("auth screen called: building...");
    return Scaffold(
        backgroundColor: Colors.orange.shade200,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.all(30),
            child: const RotationTransition(
              turns: AlwaysStoppedAnimation(-15 / 360),
              child: Text('FlutterChat!',
                  style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(4.0, 4.0),
                            blurRadius: 9.0,
                            color: Colors.black45)
                      ])),
            ),
          ),
          AuthForm(onSubmit: _submitAuthForm, loading: _isLoading)
        ])));
  }
}
