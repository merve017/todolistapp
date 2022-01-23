import 'package:todolist_app/screens/authentication/components/signin.dart';
import 'package:flutter/material.dart';

import 'components/signin.dart';

class AuthenticationScreen extends StatefulWidget {
  final String? title;
  final Widget? widget;
  const AuthenticationScreen({Key? key, this.title, this.widget})
      : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late String _title;
  late Widget _widget;

  @override
  void initState() {
    _title = widget.title ?? "Login";
    _widget = widget.widget ?? const SignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: (_title == "Login")
              ? Image.asset("assets/images/logo_merve.png",
                  fit: BoxFit.contain, height: 32)
              : null,
          title: (_title == "Login")
              ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Image.asset("assets/images/beschriftung.png",
                      fit: BoxFit.contain, height: 32),
                  Text(_title)
                ])
              : Text(_title),
          centerTitle: false,
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
        ),
        body: SafeArea(child: SingleChildScrollView(child: _widget)));
  }
}
