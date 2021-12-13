import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/authentication/emailverification_screen.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isObscurePassword = true;
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onChanged: (val) {
        setState(() => firstName = val);
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          hintText: "First Name",
          contentPadding: const EdgeInsets.all(8),
          hintStyle: kHintStyle,
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder: kOutlineBorder,
          focusedBorder: kOutlineBorder,
          errorBorder: kOutLineErrorBorder,
          focusedErrorBorder: kOutLineErrorBorder),
    );

    //last name field
    final lastNameField = TextFormField(
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Last Name cannot be Empty");
        }
        return null;
      },
      onChanged: (val) {
        setState(() => lastName = val);
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          hintText: "Last Name",
          contentPadding: const EdgeInsets.all(8),
          hintStyle: kHintStyle,
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder: kOutlineBorder,
          focusedBorder: kOutlineBorder,
          errorBorder: kOutLineErrorBorder,
          focusedErrorBorder: kOutLineErrorBorder),
    );

    //email field
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

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please enter a password");
        } else if (value.length < 6) {
          return ('Enter a password 6+ chars long');
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid Password(Min. 6 Character)");
        }
      },
      onChanged: (val) {
        setState(() => password = val);
      },
      textInputAction: TextInputAction.next,
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
                isObscure ? Icons.radio_button_off : Icons.radio_button_checked,
              ))),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (confirmPassword != password) {
          return "Password don't match";
        }
        return null;
      },
      onChanged: (val) {
        setState(() => confirmPassword = val);
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          prefixIcon: const Icon(Icons.lock),
          hintText: "Confirm password",
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
                  isObscure = !isObscurePassword;
                  isObscurePassword = !isObscurePassword;
                });
              },
              child: Icon(
                isObscurePassword
                    ? Icons.radio_button_off
                    : Icons.radio_button_checked,
              ))),
    );

    //signup button
    final signUpButton = ElevatedButton(
        child: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            dynamic result = await AuthService.registerWithEmailAndPassword(
                email, password, firstName, lastName);
            if (result == null) {
              setState(() {
                loading = false;
                error = result;
              });
            }
            try {
              if (result.uid != null) {
                Fluttertoast.showToast(msg: "registered Successful");
                AuthService.sendEmailVerificationToRegisteredMail();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailVerificationScreen(),
                    ));
              }
            } on NoSuchMethodError {
              setState(() {
                loading = false;
                error = result;
              });
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
                    const SizedBox(height: 20.0),
                    firstNameField,
                    const SizedBox(height: 20),
                    lastNameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
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
