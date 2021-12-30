import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist_app/models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? user = _auth.currentUser;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '556311770094-r3fip0prjd35s11evud3ioch7lr5k1s0.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static UserModel userFromFirebase(User user) {
    return UserModel(uid: user.uid);
  }

  static Future signInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  static Future signInWithEmailAndPassword(
      String email, String password) async {
    String errorMessage = "";
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      return user;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      print(error.code);
      return errorMessage;
    }
  }

  // register with email and password
  static Future registerWithEmailAndPassword(
      String email, String password, String firstname, String lastname) async {
    String errorMessage = "";
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      postDetailsToFirestore(firstname, lastname);

      user = result.user;
      // create a new document for the user with the uid
      return userFromFirebase(user as User);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return errorMessage;
    }
  }

  static void postDetailsToFirestore(String firstname, String lastname) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel(uid: user!.uid);

    // writing all the values
    userModel.email = user!.email;
    userModel.firstName = firstname;
    userModel.lastName = lastname;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
  }

  static Future sendEmailVerificationToRegisteredMail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Verifies user's email ID by checking email verification link has been clicked
  static Future<bool> checkEmailHasBeenVerified() async {
    // await user!.reload();
    user = _auth.currentUser;
    if (user!.emailVerified) {
      return true;
    } else {
      return false;
    }
  }

  // sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        _googleSignIn.signOut();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  static Future<bool> signInWithGoogle({required BuildContext context}) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;
        final AuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      Fluttertoast.showToast(
        msg: ('Sign In ${user!.uid} with Google'),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // ...
      } else if (e.code == 'invalid-credential') {
        // ...
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: ('Failed to sign in with Google: $e'),
      );
    }
    return false;
  }

/*
  @override
  Future<String> signInWithFacebook() async {
    final result = await _facebookLogin.logInWithReadPermissions(['email']);

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );
    return (await _auth.signInWithCredential(credential)).user.uid;
  }
*/
  static Future<bool> doUserResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
