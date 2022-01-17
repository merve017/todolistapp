import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';

class ToDoTile extends StatelessWidget {
  final Todo todo;
  final int index;

  const ToDoTile({Key? key, required this.todo, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedExpansionTile = -1;

    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
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
                selectedExpansionTile = index;
              } else {
                selectedExpansionTile = -1;
              }
              (context as Element).markNeedsBuild();
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
                  todo.status = value;
                  todo.doneDate = todo.status == true ? DateTime.now() : null;
                  TodoService()
                      .updateByID(todo.toJson(todo), todo.uid as String);
                  (context as Element).markNeedsBuild();
                }),
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: todo.status!
                          ? const Text('Status: Fertig!')
                          : const Text('Status: Offen!', softWrap: true))),
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
}
