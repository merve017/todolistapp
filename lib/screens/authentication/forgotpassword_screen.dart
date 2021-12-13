import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/screens/authentication/signin_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';
  String error = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onChanged: (val) {
        setState(() => email = val);
      },
      textInputAction: TextInputAction.next,
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
    );
    //signup button
    final signUpButton = ElevatedButton(
        child: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            bool result = await AuthService.doUserResetPassword(email);
            if (result == false) {
              setState(() {
                loading = false;
                error = "E-Mail has not been found!";
              });
            }
            if (result) {
              Fluttertoast.showToast(
                  msg: "Password instructions send via E-Mail");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignIn(),
                  ));
            }
          }
        });

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.lightBlue[50],
            appBar: AppBar(
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              title:
                  const Text('Register', style: TextStyle(color: Colors.white)),
              centerTitle: false,
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    emailField,
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
            ),
          );
  }
}
