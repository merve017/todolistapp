import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool loading = false;
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;
  int selectedExpansionTile = -1;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : ListView(
            //controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
                openTodos(),
                closedTodos(),
              ]);

    /*ListView(physics: const ClampingScrollPhysics(), children: [
            openTodos(),
            closedTodos(),
          ]);*/
    /*StreamBuilder<QuerySnapshot>(
            stream: TodoService().getTodoListOfCurrentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              const Loading();
              if (snapshot.hasError) {
                return const Text("Something went wrong");
                // Fluttertoast.showToast(msg: 'Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text(
                    "Loading",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (snapshot.data!.size == 0) {
                return const Center(child: Text("All ToDos are caught up"));
              } else {
                // if (snapshot.hasData && snapshot.data!.size > 0) {
                return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView(children: [
                      ExpansionTile(
                        title: const Text("Open"),
                        initiallyExpanded: true,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Todo todo = Todo.fromJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return toDoTile(context, todo, index);
                              })
                        ],
                      )
                    ]));
              }
            },
          );*/
  }

  Widget toDoTile(BuildContext context, Todo todo, int index) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (context) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTodo(
                    todo: todo,
                  ),
                ),
              )
            },
          ),
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            onPressed: (context) =>
                {TodoService().deleteByID(todo.uid as String)},
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          child: ExpansionTile(
            initiallyExpanded: index == selectedExpansionTile,
            onExpansionChanged: ((newState) {
              if (newState) {
                setState(() {
                  selectedExpansionTile = index;
                });
              } else {
                setState(() {
                  selectedExpansionTile = -1;
                });
              }
            }),
            leading: Icon(Icons.fiber_manual_record, color: color(todo)),
            title: Text(
              todo.title,
              style: const TextStyle(color: Colors.black),
              maxLines: 2,
            ),
            trailing: Checkbox(
                value: todo.status,
                onChanged: (value) {
                  setState(() {
                    todo.status = value;
                    todo.doneDate = todo.status == true ? DateTime.now() : null;
                    TodoService()
                        .updateByID(todo.toJson(todo), todo.uid as String);
                  });
                }),
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: todo.status!
                          ? const Text('Status: Done!')
                          : const Text('Status: Open!', softWrap: true))),
              placeHolder,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Description: ${todo.description}',
                        softWrap: true),
                  )),
              placeHolder,
            ],
          ),
          //  )  trailing: const Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  Widget openTodos() {
    return StreamBuilder<QuerySnapshot>(
        stream: TodoService().getTodoListOfCurrentUserofOpenTodos(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return loadingScreens(snapshot, "Offene To-Do's");
        });
  }

  Widget closedTodos() {
    return StreamBuilder<QuerySnapshot>(
        stream: TodoService().getTodoListOfCurrentUserofClosedTodos(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return loadingScreens(snapshot, "Erledigte To-Do's");
        });
  }

  Widget loadingScreens(AsyncSnapshot<QuerySnapshot> snapshot, String title) {
    const Loading();
    if (snapshot.hasError) {
      return const Text("Etwas ging schief - bitte aktualisiere die Seite");
      // Fluttertoast.showToast(msg: 'Something went wrong');
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Text(
          "Laden...",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (snapshot.data!.size == 0) {
      return const Center(child: Text("Keine offenen Todos vorhanden"));
    } else {
      // if (snapshot.hasData && snapshot.data!.size > 0) {
      return ExpansionTile(
          title: Text(title),
          initiallyExpanded: true,
          children: [
            SizedBox(
                //height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Todo todo = Todo.fromJson(snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>);
                      return toDoTile(context, todo, index);
                    }))
          ]);
    }
  }
}

MaterialColor color(Todo todo) {
  if (todo.status == true) {
    return Colors.green;
  } else {
    switch (todo.priority) {
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
}
