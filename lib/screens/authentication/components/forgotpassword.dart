import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/screens/authentication/authentication_screen.dart';
import 'package:todolist_app/screens/authentication/components/form_fields.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/loading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();
  String error = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signUpButton = ElevatedButton(
        child: const Text(
          'Passwort zurücksetzen',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            bool result = await AuthService.doUserResetPassword(_email.text);
            if (result == false) {
              setState(() {
                loading = false;
                error = "E-Mail wurde nicht gefunden!";
              });
            }
            if (result) {
              Fluttertoast.showToast(
                  msg:
                      "Link zum Zurücksetzen des Passworts wurde an die E-Mail Adresse verschickt");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthenticationScreen(),
                  ));
            }
          }
        });

    return loading
        ? const Loading()
        : Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  EmailField(controller: _email),
                  const SizedBox(height: 20),
                  signUpButton,
                  const SizedBox(height: 15),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          );
  }
}
