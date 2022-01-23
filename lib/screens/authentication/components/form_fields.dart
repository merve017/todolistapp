import 'package:flutter/material.dart';
import 'package:todolist_app/shared/constants.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  const EmailField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          prefixIcon: const Icon(Icons.email),
          hintText: "E-mail Addresse eingeben",
          hintStyle: kHintStyle,
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder: kOutlineBorder,
          focusedBorder: kOutlineBorder,
          errorBorder: kOutLineErrorBorder,
          focusedErrorBorder: kOutLineErrorBorder),
      validator: (val) {
        if (val!.isEmpty) {
          return ("Bitte E-Mail Adresse eingeben");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val)) {
          return ("Bitte E-Mail Adresse eingeben");
        }
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  final VoidCallback stateSetter;
  final TextEditingController controller;
  final bool isObscure;

  const PasswordField(
      {Key? key,
      required this.stateSetter,
      required this.controller,
      required this.isObscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: isObscure,
        validator: (val) {
          if (val!.isEmpty) {
            return ("Passwort eingeben");
          } else if (val.length < 6) {
            return ('Passwort muss über 6 Zeichen sein');
          }
          RegExp regex = RegExp(r'^.{6,}$');
          if (!regex.hasMatch(val)) {
            return ("Passwort eingeben(min. 6 Zeichen)");
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            prefixIcon: const Icon(Icons.lock),
            hintText: "Passwort eingeben",
            hintStyle: kHintStyle,
            fillColor: Colors.grey[200],
            filled: true,
            enabledBorder: kOutlineBorder,
            focusedBorder: kOutlineBorder,
            errorBorder: kOutLineErrorBorder,
            focusedErrorBorder: kOutLineErrorBorder,
            suffixIcon: InkWell(
                onTap: stateSetter,
                child: Icon(
                  isObscure
                      ? Icons.radio_button_off
                      : Icons.radio_button_checked,
                ))));
  }
}

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final String name;

  const NameField({Key? key, required this.controller, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("$name darf nicht leer sein");
        }
        if (!regex.hasMatch(value)) {
          return ("name eingeben(min. 2 Zeichen)");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          hintText: name,
          contentPadding: const EdgeInsets.all(8),
          hintStyle: kHintStyle,
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder: kOutlineBorder,
          focusedBorder: kOutlineBorder,
          errorBorder: kOutLineErrorBorder,
          focusedErrorBorder: kOutLineErrorBorder),
    );
  }
}
