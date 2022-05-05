import 'package:flutter/material.dart';
import 'dart:io';
//
import './image_select.dart';

enum AuthMode { Login, Signup }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.onSubmit, this.loading = false})
      : super(key: key);

  final void Function(String email, String password, String username,
      File? image, bool isLogin) onSubmit;
  final bool loading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  AuthMode _mode = AuthMode.Login;
  final Map<String, dynamic> _userInfo = {
    'email': '',
    'username': '',
    'password': '',
    'image': null,
  };

  void _getImage(File image) {
    setState(() {
      _userInfo['image'] = image;
    });
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final bool isValid = (_formKey.currentState as FormState).validate();

    if (_mode == AuthMode.Signup && _userInfo['image'] == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('please pick an image.')));
    }

    if (isValid) {
      _formKey.currentState?.save();
      widget.onSubmit(
          (_userInfo['email'] as String).trim(),
          (_userInfo['password'] as String).trim(),
          (_userInfo['username'] as String).trim(),
          (_userInfo['image']),
          _mode == AuthMode.Login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(20),
        elevation: 10,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_mode == AuthMode.Signup)
                          ImageSelect(
                            getImageFn: _getImage,
                          ),
                        TextFormField(
                          key: const ValueKey('email'),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@') ||
                                value.length < 5) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'email address',
                          ),
                          onSaved: (value) {
                            _userInfo['email'] = value as String;
                          },
                        ),
                        if (_mode == AuthMode.Signup)
                          TextFormField(
                            key: const ValueKey('username'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 3) {
                                return 'Please enter a valid username (at least 3 characters).';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'username'),
                            onSaved: (value) {
                              _userInfo['username'] = value as String;
                            },
                          ),
                        TextFormField(
                            key: const ValueKey('password'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6) {
                                return 'Please enter a valid password (at least 6 characters).';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'password'),
                            obscureText: true,
                            onSaved: (value) {
                              _userInfo['password'] = value as String;
                            }),
                        const SizedBox(
                          height: 24,
                        ),
                        widget.loading
                            ? Center(child: CircularProgressIndicator())
                            : Column(children: [
                                ElevatedButton(
                                  child: Text(
                                      _mode == AuthMode.Login
                                          ? 'log in'
                                          : 'sign up',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: _trySubmit,
                                ),
                                TextButton(
                                  child: Text(
                                      _mode == AuthMode.Login
                                          ? 'create an account'
                                          : 'I already have an account. Let me log in.',
                                      style: TextStyle(fontSize: 10)),
                                  onPressed: () {
                                    if (_mode == AuthMode.Login) {
                                      setState(() {
                                        _mode = AuthMode.Signup;
                                      });
                                    } else {
                                      setState(() {
                                        _mode = AuthMode.Login;
                                      });
                                    }
                                  },
                                )
                              ])
                      ],
                    )))));
  }
}
