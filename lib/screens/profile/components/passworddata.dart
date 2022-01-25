import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/screens/authentication/components/form_fields.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';

class PasswordData extends StatefulWidget {
  const PasswordData({Key? key}) : super(key: key);

  @override
  _PasswordDataState createState() => _PasswordDataState();
}

class _PasswordDataState extends State<PasswordData> {
  final _formKey = GlobalKey<FormState>();
  bool isObscureFirstPassword = true;
  bool isObscureSecondPassword = true;
  String error = '';
  bool loading = false;

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Profil Information ändern"),
              backgroundColor: Colors.lightBlue[100],
              elevation: 0.0,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    size: 35,
                  ),
                  color: Colors.greenAccent,
                  onPressed: () => submit(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    size: 35,
                  ),
                  color: Colors.redAccent,
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            body: SingleChildScrollView(
                controller: ScrollController(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        placeHolder,
                        PasswordField(
                          stateSetter: passwordStateSetter,
                          controller: password,
                          isObscure: isObscureFirstPassword,
                        ),
                        placeHolder,
                        PasswordField(
                          stateSetter: confirmPasswordStateSetter,
                          controller: confirmPassword,
                          isObscure: isObscureSecondPassword,
                        ),
                        placeHolder,
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ))));
  }

  submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      if (password.text == confirmPassword.text) {
        AuthService.user!.updatePassword(password.text);
        Fluttertoast.showToast(msg: "Änderungen wurden gespeichert");
        Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
          error = "Passwörter passen nicht zusammen!";
        });
      }
    }
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
