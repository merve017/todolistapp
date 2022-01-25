import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

const kHintStyle = TextStyle(
  fontSize: 13,
  letterSpacing: 1.2,
);

//border
var kOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(color: Colors.transparent),
);

var kOutLineErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(color: Colors.red),
);

const kLoaderBtn = SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
        strokeWidth: 1.5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));

const kHeadingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

InputDecoration textFormFieldDecoration(String title) {
  return InputDecoration(
      contentPadding: const EdgeInsets.all(8),
      prefixIcon: const Icon(Icons.description),
      hintText: title,
      hintStyle: kHintStyle,
      fillColor: Colors.grey[200],
      filled: true,
      enabledBorder: kOutlineBorder,
      focusedBorder: kOutlineBorder,
      errorBorder: kOutLineErrorBorder,
      focusedErrorBorder: kOutLineErrorBorder);
}

Widget textLabel(text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: SizedBox(
      height: 25,
      child: Text(text),
    ),
  );
}

const placeHolder = SizedBox(
  height: 20,
);

enum Repetition { none, daily, weekly, monthly, yearly }

extension RepetitionExtension on Repetition {
  String get name {
    switch (this) {
      case Repetition.weekly:
        return 'Wöchentlich';
      case Repetition.monthly:
        return 'Monatlich';
      case Repetition.yearly:
        return 'Jährlich';
      default:
        return 'keine Wiederholung';
    }
  }
}

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFFB3E5FC);
const bgColor = Colors.white;

const defaultPadding = 16.0;

MaterialColor color(dynamic task) {
  try {
    if (task.status == true) {
      return Colors.green;
    }
  } catch (e) {
    if (task.dueDate.isBefore(DateTime.now())) {
      return Colors.green;
    }
  }

  switch (task.priority) {
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.orange;
    case 4:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Color? backgroundColorOpen(priority) {
  switch (priority) {
    case 2:
      return Colors.yellow[50];
    case 3:
      return Colors.orange[50];
    case 4:
      return Colors.red[50];
    default:
      return Colors.grey[50];
  }
}

Widget? snapshotLoader(AsyncSnapshot<QuerySnapshot> snapshot) {
  const Loading();
  if (snapshot.hasError) {
    return const Text("Etwas ging schief - bitte aktualisiere die Seite");
    // Fluttertoast.showToast(msg: 'Something went wrong');
  } else if (snapshot.connectionState == ConnectionState.waiting) {
    return const Loading();
  } else {
    return null;
  }
}
