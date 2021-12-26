import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/loading.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool loading = false;
  // late final VoidCallback onPressed;
  int selectedExpansionTile = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : StreamBuilder<QuerySnapshot>(
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
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Todo todo = Todo.fromJson(snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>);
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
                              onPressed: (context) => {
                                TodoService().deleteByID(todo.uid as String)
                              },
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
                              leading: Icon(Icons.fiber_manual_record,
                                  color: color(todo)),
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
                                      todo.doneDate = todo.status == true
                                          ? DateTime.now()
                                          : null;
                                      TodoService().updateByID(
                                          todo.toJson(todo),
                                          todo.uid as String);
                                    });
                                  }),
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: todo.status!
                                            ? const Text('Status: Done!')
                                            : const Text('Status: Open!',
                                                softWrap: true))),
                                const SizedBox(height: 10),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                          'Description: ${todo.description}',
                                          softWrap: true),
                                    )),
                                const SizedBox(height: 10),
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('priority:', softWrap: true),
                                    )),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SfSlider(
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.blueGrey,
                                          value: todo.priority,
                                          stepSize: 1,
                                          max: 4,
                                          min: 1,
                                          interval: 1,
                                          showLabels: true,
                                          labelFormatterCallback:
                                              (dynamic actualValue,
                                                  String formattedText) {
                                            switch (actualValue) {
                                              case 4:
                                                return 'high';
                                              case 3:
                                                return 'medium';
                                              case 2:
                                                return 'low';
                                              default:
                                                return 'not prioritized';
                                            }
                                          },
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              todo.priority = value as int;
                                              TodoService().updateByID(
                                                  todo.toJson(todo),
                                                  todo.uid as String);
                                            });
                                          },
                                        ))),
                              ],
                            ),
                            //  )  trailing: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          );
  }
}

MaterialColor color(Todo todo) {
  if (todo.status == true) {
    return Colors.green;
  } else {
    switch (todo.priority) {
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.orange;
        break;
      case 4:
        return Colors.red;
        break;
      default:
        return Colors.grey;
    }
  }
}
