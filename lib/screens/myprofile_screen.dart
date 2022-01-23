import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/models/user_model.dart';
import 'package:todolist_app/screens/authentication/components/form_fields.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signUpButton = ElevatedButton(
        child: const Text(
          'Aktualisieren',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            userModel.firstName = firstName.text;
            userModel.lastName = lastName.text;
            AuthService().update(userModel.toJson(userModel));
            AuthService.user!.updateDisplayName(userModel.firstName);
            //AuthService.user!.verifyBeforeUpdateEmail(userModel.email);

            Fluttertoast.showToast(msg: "Änderungen wurden gespeichert!");
            setState(() {
              loading = false;
            });
          }
        });

    return FutureBuilder<UserModel>(
        future: getUserData(),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            userModel = snapshot.data as UserModel;
            firstName.text = userModel.firstName!;
            lastName.text = userModel.lastName!;
            email.text = userModel.email!;
            return Container(
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
          } else {
            return const Loading();
          }
        });
  }

  Future<UserModel> getUserData() async {
    return (await AuthService.userFromFirebase()) as UserModel;
  }
}
