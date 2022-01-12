import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_app/models/user_model.dart';
import 'package:todolist_app/screens/authentication/signin_screen.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/screens/eisenhower_screen.dart';
import 'package:todolist_app/screens/myprofile_screen.dart';
import 'package:todolist_app/screens/routine_list_screen.dart';
import 'package:todolist_app/screens/statistics_screen.dart';
import 'package:todolist_app/screens/todo_list_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'calendar/calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final Widget? widget;
  const HomeScreen({Key? key, this.widget}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();
  String _title = 'To-Do List';
  late Widget _widget;

  @override
  void initState() {
    _widget = widget.widget ?? const EventCalendar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.lightBlue[100],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.priority_high_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _title = "Eisenhower-Matrix";
                _widget = const EisenhowerScreen();
              });
            },
          )
          // : const Text(''),
          ,
          IconButton(
            icon:
                const Icon(Icons.calendar_today_outlined, color: Colors.white),
            onPressed: () {
              setState(() {
                _title = "Kalender";
                _widget = const EventCalendar();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //_title = "Todo hinzufügen";
                  builder: (context) => const AddEditTodo(),
                ),
              );
            },
          ),
        ],
      ),
      body: _widget,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
              ),
              child: Text(
                  'Hello ${AuthService.userFromFirebase(AuthService.user as User).firstName ?? AuthService.user!.displayName}',
                  style: const TextStyle(
                    color: Colors.black54,
                  )),
            ),
            ListTile(
              title: const Text('Meine aktuellen To-Dos'),
              onTap: () {
                setState(() {
                  _title = "To-Do Liste";
                  _widget = const TodoList();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Alle To-Dos'),
              onTap: () {
                setState(() {
                  _title = "To-Do Liste";
                  _widget = const TodoList();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Routinetätigkeiten verwalten'),
              onTap: () {
                setState(() {
                  _title = "Meine Routineaktivitäten";
                  _widget = const RoutineList();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('Statistics'),
              iconColor: Colors.black,
              onTap: () {
                setState(() {
                  _title = "Statistiken";
                  _widget = const StatisticsScreen();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              iconColor: Colors.black,
              onTap: () {
                setState(() {
                  _title = "Einstellungen";
                  _widget = const MyProfileScreen();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Logout'),
              iconColor: Colors.black,
              onTap: () async {
                await AuthService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignIn(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
