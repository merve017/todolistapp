import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/screens/authentication/forgotpassword_screen.dart';
import 'package:todolist_app/screens/authentication/register_screen.dart';
import 'package:todolist_app/screens/authentication/emailverification_screen.dart';
import 'package:todolist_app/screens/home_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';
import 'package:flutter/material.dart';

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
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.lightBlue[50],
            appBar: AppBar(
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              title: const Text('Login', style: TextStyle(color: Colors.white)),
              centerTitle: false,
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Enter e-mail address",
                          hintStyle: kHintStyle,
                          fillColor: Colors.grey[200],
                          filled: true,
                          enabledBorder: kOutlineBorder,
                          focusedBorder: kOutlineBorder,
                          errorBorder: kOutLineErrorBorder,
                          focusedErrorBorder: kOutLineErrorBorder),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(val)) {
                          return ("Please Enter a valid email");
                        }
                      },
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        obscureText: isObscure,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("Please enter a password");
                          } else if (val.length < 6) {
                            return ('Enter a password 6+ chars long');
                          }
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (!regex.hasMatch(val)) {
                            return ("Enter a valid Password(Min. 6 Character)");
                          }
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            prefixIcon: const Icon(Icons.lock),
                            hintText: "Enter password",
                            hintStyle: kHintStyle,
                            fillColor: Colors.grey[200],
                            filled: true,
                            enabledBorder: kOutlineBorder,
                            focusedBorder: kOutlineBorder,
                            errorBorder: kOutLineErrorBorder,
                            focusedErrorBorder: kOutLineErrorBorder,
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                child: Icon(
                                  isObscure
                                      ? Icons.radio_button_off
                                      : Icons.radio_button_checked,
                                )))),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await AuthService.signInWithEmailAndPassword(
                                    email, password);
                            bool verifiedEmail =
                                await AuthService.checkEmailHasBeenVerified();
                            try {
                              if (result.uid != null && !verifiedEmail) {
                                Fluttertoast.showToast(
                                    msg: 'E-Mail is not verified!');
                                AuthService
                                    .sendEmailVerificationToRegisteredMail();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EmailVerificationScreen(),
                                    ));
                              }
                              if (result.uid != null && verifiedEmail) {
                                Fluttertoast.showToast(msg: "Login Successful");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
                              }
                            } on NoSuchMethodError {
                              setState(() {
                                loading = false;
                                error = result;
                              });
                            }
                          }
                        }),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    TextButton(
                        child: const Text("Forgot password?"),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()))),
                    const Divider(height: 20, endIndent: 10, indent: 8),
                    const SizedBox(height: 20),
                    TextButton(
                      child: const Text("Create an Account"),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register())),
                    ),
                    const SizedBox(height: 20),
                    const Text("or"),
                    const SizedBox(height: 20),
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
                                      builder: (context) =>
                                          const HomeScreen()));
                            }
                          },
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
