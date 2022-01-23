library homescreen;

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todolist_app/models/user_model.dart';
import 'package:todolist_app/screens/authentication/authentication_screen.dart';
import 'package:todolist_app/shared/constants.dart';
import 'dashboard/dashboard_screen.dart';
import 'package:todolist_app/screens/authentication/components/signin.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/screens/eisenhower_screen.dart';

import 'package:flutter/material.dart';
import 'package:todolist_app/service/auth_service.dart';

import '../responsive.dart';
import 'calendar/calendar_screen.dart';
import 'lists/actual_todo_list_screen.dart';
import 'myprofile_screen.dart';
import 'lists/routine_list_screen.dart';
import 'statistics/statistics_screen.dart';
import 'lists/todo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final Widget? widget;
  const HomeScreen({Key? key, this.widget}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();
  String _title = 'Dashboard';
  late Widget _widget;

  @override
  void initState() {
    _widget = widget.widget ?? const DashboardScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            if (Responsive.isDesktop(context)) ...[
              Image.asset("assets/images/beschriftung.png",
                  fit: BoxFit.contain, height: 32)
            ],
            Text(_title)
          ]),
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
          leading: (Responsive.isDesktop(context))
              ? Image.asset("assets/images/logo_merve.png",
                  fit: BoxFit.cover, height: 32)
              : null,
          actions: <Widget>[
            Responsive.isDesktop(context)
                ? TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEditTodo(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Neuer To-Do",
                        style: TextStyle(color: Colors.white)))
                : IconButton(
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
            if (_title.contains("To-Do")) ...[
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Colors.white,
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text("Kalenderansicht - Monat"),
                          onTap: () {
                            setState(() {
                              _title = "To-Do's - Kalender";
                              _widget = EventCalendar(
                                calendarView: CalendarView.month,
                              );
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("Kalenderansicht - Terminplan"),
                          onTap: () {
                            setState(() {
                              _title = "To-Do's - Kalender";
                              _widget = EventCalendar(
                                calendarView: CalendarView.schedule,
                              );
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("Eisenhower-Matrix"),
                          onTap: () {
                            setState(() {
                              _title = "To-Do's - Eisenhower-Matrix";
                              _widget = const EisenhowerScreen();
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("Listenansicht heute"),
                          onTap: () {
                            setState(() {
                              _title = "To-Do's - Liste";
                              _widget = const ActualTodoList();
                            });
                          },
                        ),
                      ]),
            ],
          ],
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context))
                Expanded(
                  flex: 2,
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: sidemenu(),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 8,
                child: _widget,
              ),
            ],
          ),
        ),
        drawer: (!Responsive.isDesktop(context)) ? sidemenu() : null);
  }

  Drawer sidemenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (!Responsive.isDesktop(context) == true) ...[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
              ),
              child: const Expanded(
                  child: Image(
                image: AssetImage("assets/images/logo_beschriftung.png"),
              )),
            )
          ],
          sideMenuListTile(const Icon(Icons.dashboard_rounded), 'Dashboard',
              const DashboardScreen()),
          sideMenuListTile(const Icon(Icons.done), 'Aktuelle To-Dos',
              const ActualTodoList()),
          sideMenuListTile(const Icon(Icons.done_all_rounded), 'Alle To-Dos',
              const TodoList()),
          sideMenuListTile(const Icon(Icons.replay), 'Routineaktivitäten',
              const RoutineList()),
          sideMenuListTile(const Icon(Icons.bar_chart_rounded), 'Statistik',
              const StatisticsScreen()),
          sideMenuListTile(const Icon(Icons.settings), 'Einstellungen',
              const MyProfileScreen()),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () async {
              await AuthService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthenticationScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile sideMenuListTile(Icon icon, String title, dynamic screen) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onTap: () {
        setState(() {
          _title = title;
          _widget = screen;
        });

        if (!Responsive.isDesktop(context)) Navigator.of(context).pop();
      },
    );
  }
}
