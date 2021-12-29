import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/service/auth_service.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Wrap(children: [
          Text(
            'Hello ${AuthService.userFromFirebase(AuthService.user as User).firstName ?? AuthService.user!.displayName}',
          )
        ])));
  }
}
