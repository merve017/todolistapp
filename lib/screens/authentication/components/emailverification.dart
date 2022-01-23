import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/authentication/authentication_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late Timer _timer;

  _EmailVerificationScreenState() {
    _timer = Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthenticationScreen(),
          ));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 5),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AuthenticationScreen();
                },
              ),
            );
          },
        ),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: ListView(shrinkWrap: true, children: [
              placeHolder,
              const ListTile(
                  title: Text(
                      "Eine E-Mail wurde an die angegebene Adresse geschickt:  ")),
              placeHolder,
              ListTile(
                title: Text("${AuthService.user!.email}",
                    style: const TextStyle(color: Colors.lightBlueAccent)),
              ),
              const ListTile(
                  title: Text(
                      "Klicke den Link in der E-Mail um dich zu verifizieren.")),
            ]),
          );
        });
  }
}
