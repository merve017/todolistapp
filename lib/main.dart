//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/authentication/signin_screen.dart';

/*import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/screens/forgot_password_screen.dart';
import 'package:todolist_app/screens/home_screen.dart';
import 'package:todolist_app/screens/login_screen.dart';
import 'package:todolist_app/screens/signup_screen.dart';
*/
//import 'app_routes.dart';
//import 'package:firebase/firebase.dart' as WebFirebase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBezYAzkkmBIaKnD2CUL69xUvXPjgXnoe4",
              authDomain: "fh-todolistapp.firebaseapp.com",
              projectId: "fh-todolistapp",
              storageBucket: "fh-todolistapp.appspot.com",
              messagingSenderId: "556311770094",
              appId: "1:556311770094:web:9977718ced6f7a1a7654ff",
              measurementId: "G-Q7QD6K98Z0"));
    } else {
      await Firebase.initializeApp();
    }
  } else {
    Firebase.apps;
  }*/
  await Firebase.initializeApp();
  //FirebaseAuth auth = FirebaseAuth.instance;
  //await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  runApp(const MyApp());
}

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "To-Do List",
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        initialRoute: AppRoutes.login,
        routes: <String, WidgetBuilder>{
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.signup: (_) => const SignUpScreen(),
          AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
        },
      ),
    );
  }
  
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
        value: AuthService().user,
          initialData: UserModel(uid: "test"),
        child: MaterialApp(
          title: "To-Do List",
          theme: ThemeData(primarySwatch: Colors.lightBlue),
          home: const Wrapper(),
        ));
  }*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ToDo List App',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        debugShowCheckedModeBanner: false,
        home: const SignIn(),
      );
}
