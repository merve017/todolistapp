import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

class EisenhowerScreen extends StatefulWidget {
  const EisenhowerScreen({Key? key}) : super(key: key);

  @override
  _EisenhowerScreenState createState() => _EisenhowerScreenState();
}

class _EisenhowerScreenState extends State<EisenhowerScreen> {
  /*void _onChangeScreenMode() {
    widget.onChangeScreenMode(!widget.fullScreenMode);
  }*/
  double dividerSize = 3.0;
  double paddingSize = 1.5;
  late EdgeInsets titlePadding;
  late TextStyle? titleTextStyle;
  List<Todo> prioHigh = [];
  List<Todo> prioMiddle = [];
  List<Todo> prioLow = [];
  List<Todo> prioNothing = [];

  Widget _buildMatrix(
      {required double dividerSize,
      required double paddingSize,
      required EdgeInsets titlePadding,
      required TextStyle titleTextStyle,
      required bool withBorders,
      required AsyncSnapshot<QuerySnapshot> snapshot}) {
    const dividerColor = Colors.transparent;
    fillLists(snapshot);
    return Scaffold(
      backgroundColor: Colors.white,
      //getCeilTitleColor(context),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            GestureDetector(
              //onTap: _onChangeScreenMode,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(paddingSize),
                      child: Text(
                        '',
                        style:
                            titleTextStyle.copyWith(color: Colors.transparent),
                      ),
                    ),
                  ),
                  rotatedBox(titlePadding, 'Dringend', titleTextStyle),
                  rotatedBox(titlePadding, 'Nicht dringend', titleTextStyle),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    //onTap: _onChangeScreenMode,
                    child: Row(
                      children: <Widget>[
                        normalBox(titlePadding, 'Wichtig', titleTextStyle),
                        normalBox(
                            titlePadding, 'Nicht Wichtig', titleTextStyle),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              listitems(prioHigh, 4),
                              Container(
                                height: dividerSize,
                                color: dividerColor,
                              ),
                              listitems(prioMiddle, 3),
                            ],
                          ),
                        ),
                        Container(
                          width: dividerSize,
                          color: dividerColor,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              listitems(prioLow, 2),
                              Container(
                                height: dividerSize,
                                color: dividerColor,
                              ),
                              listitems(prioNothing, 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return openTodos();
  }

  Widget openTodos() {
    return StreamBuilder<QuerySnapshot>(
        stream: TodoService().getTodoListOfCurrentUserofOpenTodosOfTodayAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return loadingScreen(snapshot);
        });
  }

  loadingScreen(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (kIsWeb) {
      dividerSize = 12.0;
      paddingSize = 20.0;
      titlePadding =
          EdgeInsets.only(top: paddingSize, bottom: paddingSize * 0.4);
      titleTextStyle = Theme.of(context).textTheme.subtitle1;
    } else {
      dividerSize = 3.0;
      paddingSize = 1.5;
      titlePadding = EdgeInsets.only(top: 0, bottom: paddingSize);
      titleTextStyle = Theme.of(context).textTheme.subtitle2;
    }
    const Loading();
    if (snapshot.hasError) {
      //print(snapshot.error);
      return const Text("Etwas ging schief - bitte aktualisiere die Seite");
      // Fluttertoast.showToast(msg: 'Something went wrong');
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Text(
          "Laden...",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return _buildMatrix(
        dividerSize: dividerSize,
        paddingSize: paddingSize,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle as TextStyle,
        withBorders: true,
        snapshot: snapshot,
      );
    }
  }

  fillLists(AsyncSnapshot<QuerySnapshot> snapshot) {
    prioHigh.clear();
    prioMiddle.clear();
    prioLow.clear();
    prioNothing.clear();
    for (var item in snapshot.data!.docs) {
      Todo todo = Todo.fromJson(item.data() as Map<String, dynamic>);
      if (todo.dueDate != null) {
        if (todo.dueDate!.isAtSameMomentAs(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
          switch (todo.priority) {
            case 4:
              prioHigh.add(todo);
              break;
            case 3:
              prioHigh.add(todo);
              break;
            case 2:
              prioLow.add(todo);
              break;
            default:
              prioLow.add(todo);
              break;
          }
        }
      } else {
        switch (todo.priority) {
          case 4:
            prioMiddle.add(todo);
            break;
          case 3:
            prioMiddle.add(todo);
            break;
          case 2:
            prioNothing.add(todo);
            break;
          default:
            prioNothing.add(todo);
            break;
        }
      }
    }
  }

  Widget rotatedBox(
      EdgeInsets titlePadding, String title, TextStyle titleTextStyle) {
    return Expanded(
      child: RotatedBox(
          quarterTurns: -1,
          child: textBox(titlePadding, title, titleTextStyle)),
    );
  }

  Widget normalBox(
      EdgeInsets titlePadding, String title, TextStyle titleTextStyle) {
    return Expanded(child: textBox(titlePadding, title, titleTextStyle));
  }

  Widget textBox(
      EdgeInsets titlePadding, String title, TextStyle titleTextStyle) {
    return Container(
      padding: titlePadding,
      alignment: Alignment.center,
      child: Text(
        title,
        style: titleTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget listitems(List<Todo> todos, int priority) {
    return Expanded(
        child: DragTarget<Todo>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Container(
            color: backgroundColorOpen(priority),
            child: todos.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return Draggable<Todo>(
                          // Data is the value this Draggable stores.
                          data: todos[index],
                          feedback: Card(
                            color: Colors.grey,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(todos[index].title)),
                          ),
                          childWhenDragging: Card(
                            color: Colors.grey[100],
                            child: const ListTile(
                              title: Icon(Icons.done),
                            ),
                          ),
                          child: Card(
                              child: ListTile(
                            title: Text(todos[index].title),
                          )));
                    })
                : const ListTile(title: Text("Keine To-Dos")));
      },
      onAccept: (Todo todo) {
        setState(() {
          if (priority == 4) {
            todo.dueDate = DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day);
            if (todo.priority != 3) todo.priority = 4;
          } else if (priority == 2) {
            todo.dueDate = DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day);
            if (todo.priority != 1) todo.priority = 2;
          } else if (priority == 3) {
            if (todo.priority != 4) todo.priority = 3;
            if (todo.dueDate != null) {
              if (todo.dueDate!.isAtSameMomentAs(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))) {
                todo.dueDate = null;
              }
            }
          } else {
            if (todo.priority != 2) todo.priority = 1;
            if (todo.dueDate != null) {
              if (todo.dueDate!.isAtSameMomentAs(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))) {
                todo.dueDate = null;
              }
            }
          }
          TodoService().updateByID(todo.toJson(todo), todo.uid as String);
        });
      },
    ));
  }
}
