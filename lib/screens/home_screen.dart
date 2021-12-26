import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_app/models/user_model.dart';
import 'package:todolist_app/screens/authentication/signin_screen.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/screens/statistics_screen.dart';
import 'package:todolist_app/screens/todo_list_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              //    child: //const SettingsForm(),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.lightBlue[100],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditTodo(),
                ),
              );
            },
          ),
        ],
      ),
      body: const TodoList(),
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
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('Statistics'),
              iconColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              iconColor: Colors.black,
              onTap: () {
                _showSettingsPanel();
                Navigator.pop(context);
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
