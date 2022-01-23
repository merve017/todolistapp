import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/screens/authentication/authentication_screen.dart';
import 'package:todolist_app/screens/authentication/components/forgotpassword.dart';
import 'package:todolist_app/screens/authentication/components/register.dart';
import 'package:todolist_app/screens/authentication/components/emailverification.dart';
import 'package:todolist_app/screens/home_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';
import 'package:flutter/material.dart';

import 'form_fields.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  const SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  String error = '';
  bool loading = false;

  // text field state
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginButton = ElevatedButton(
        child: const Text(
          'Log In',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);

            dynamic result = await AuthService.signInWithEmailAndPassword(
                _email.text, _password.text);
            try {
              bool verifiedEmail =
                  await AuthService.checkEmailHasBeenVerified();
              if (result.uid != null && !verifiedEmail) {
                Fluttertoast.showToast(msg: 'E-Mail ist nicht verifiziert!');
                AuthService.sendEmailVerificationToRegisteredMail();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationScreen(
                          widget: EmailVerificationScreen(),
                          title: "E-Mail verifizieren"),
                    ));
              }
              if (result.uid != null && verifiedEmail) {
                Fluttertoast.showToast(msg: "Login erfolgreich");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              }
            } catch (err) {
              setState(() {
                loading = false;
                error = result;
              });
            }
          }
        });

    final registerButton = TextButton(
        child: const Text("Benutzer erstellen"),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AuthenticationScreen(
                    widget: Register(), title: "Benutzer registrieren"))));
    final passwordForgetButton = TextButton(
        child: const Text("Passwort vergessen?"),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AuthenticationScreen(
                    widget: ForgotPasswordScreen(),
                    title: "Passwort zurücksetzen"))));
    return loading
        ? const Loading()
        : Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  EmailField(controller: _email),
                  placeHolder,
                  PasswordField(
                      controller: _password,
                      stateSetter: passwordStateSetter,
                      isObscure: isObscure),
                  placeHolder,
                  loginButton,
                  placeHolder,
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  passwordForgetButton,
                  const Divider(height: 20, endIndent: 10, indent: 8),
                  placeHolder,
                  registerButton,
                  placeHolder,
                  const Text("oder"),
                  placeHolder,
                  Align(
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          bool result = await AuthService.signInWithGoogle(
                              context: context);
                          if (result) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          }
                        },
                      ))
                ],
              ),
            ),
          );
  }

  void passwordStateSetter() {
    setState(() {
      isObscure = !isObscure;
    });
  }
}
