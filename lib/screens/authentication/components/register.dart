import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/models/user_model.dart';
import 'package:todolist_app/screens/authentication/components/form_fields.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/authentication/components/emailverification.dart';

import '../authentication_screen.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool isObscureFirstPassword = true;
  bool isObscureSecondPassword = true;
  String error = '';
  bool loading = false;

  // text field state
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //signup button
    final signUpButton = ElevatedButton(
        child: const Text(
          'Registrieren',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            dynamic result;
            try {
              if (password.text != confirmPassword.text) {
                result = "Passwörter sind nicht gleich";
                throw Exception();
              }

              UserModel user = UserModel(
                  firstName: firstName.text,
                  lastName: lastName.text,
                  email: email.text);
              result = await AuthService.registerWithEmailAndPassword(
                  user, password.text);

              if (result.uid != null) {
                Fluttertoast.showToast(msg: "Registrierung war erfolgreich");
                AuthService.sendEmailVerificationToRegisteredMail();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthenticationScreen(
                            widget: EmailVerificationScreen(),
                            title: "E-Mail Verifizierung")));
              }
            } catch (e) {
              setState(() {
                loading = false;
                error = result;
              });
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
                  placeHolder,
                  NameField(controller: firstName, name: "Vorname"),
                  placeHolder,
                  NameField(controller: lastName, name: "Nachname"),
                  placeHolder,
                  EmailField(controller: email),
                  placeHolder,
                  PasswordField(
                      stateSetter: passwordStateSetter,
                      controller: password,
                      isObscure: isObscureFirstPassword),
                  placeHolder,
                  PasswordField(
                      stateSetter: confirmPasswordStateSetter,
                      controller: confirmPassword,
                      isObscure: isObscureSecondPassword),
                  placeHolder,
                  signUpButton,
                  placeHolder,
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          );
  }

  void passwordStateSetter() {
    setState(() {
      isObscureFirstPassword = !isObscureFirstPassword;
    });
  }

  void confirmPasswordStateSetter() {
    setState(() {
      isObscureSecondPassword = !isObscureSecondPassword;
    });
  }
}
