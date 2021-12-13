import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/authentication/signin_screen.dart';
import 'package:todolist_app/service/auth_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late Timer _timer;

  /*@override
  void initState() {
    super.initState();*/
  _EmailVerificationScreenState() {
    _timer = Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SignIn(),
              settings: const RouteSettings(name: '/signin')));
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
                  return const SignIn();
                },
              ),
            );
          },
        ),
        builder: (context, snapshot) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                        text: "An email has been sent to the address ",
                        children: [
                          TextSpan(
                            text: "${AuthService.user!.email}",
                            style:
                                const TextStyle(color: Colors.lightBlueAccent),
                          ),
                          const TextSpan(
                              text: " please click on the link to verify it."),
                        ]),
                  )
                ],
              ),
            ),
          );
        });
  }
}
