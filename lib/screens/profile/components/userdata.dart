import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/models/user_model.dart';
import 'package:todolist_app/screens/authentication/components/form_fields.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  late UserModel userModel;
  final _formKey = GlobalKey<FormState>();
  bool isObscureFirstPassword = true;
  bool isObscureSecondPassword = true;
  String error = '';
  bool loading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Passwort ändern"),
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
                child: StreamBuilder<DocumentSnapshot>(
                    stream: AuthService().userFromFirebaseStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      const Loading();
                      if (snapshot.hasError) {
                        return const Text("Leider ging etwas schief!");
                        // Fluttertoast.showToast(msg: 'Something went wrong');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Text(
                            "Loading",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        userModel = UserModel.fromJson(snapshot.data);
                        firstName.text = userModel.firstName!;
                        lastName.text = userModel.lastName!;
                        email.text = userModel.email!;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                placeHolder,
                                NameField(
                                    controller: firstName, name: "Vorname"),
                                placeHolder,
                                NameField(
                                    controller: lastName, name: "Nachname"),
                                placeHolder,
                                EmailField(controller: email),
                                placeHolder,
                                Text(
                                  error,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }))));
  }

  submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      if (userModel.firstName != firstName.text) {
        userModel.firstName = firstName.text;
        AuthService.user!.updateDisplayName(userModel.firstName);
      }
      userModel.lastName = lastName.text;
      if (userModel.email != email.text) {
        userModel.email = email.text;
        AuthService.user!.verifyBeforeUpdateEmail(userModel.email ?? '');
      }
      AuthService().update(userModel.toJson(userModel));

      Fluttertoast.showToast(msg: "Änderungen wurden gespeichert!");

      Navigator.pop(context);
    }
  }
}
