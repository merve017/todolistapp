import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/shared/constants.dart';

import 'todo_tile.dart';

class ListStreamBuilder extends StatelessWidget {
  final dynamic query;
  final String? site;
  final List<Todo> todos = [];
  final List<Todo> actualtodos = [];
  ListStreamBuilder({Key? key, required this.query, this.site})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return loadingScreens(snapshot);
        });
  }

  Widget loadingScreens(AsyncSnapshot<QuerySnapshot> snapshot) {
    Widget? loader = snapshotLoader(snapshot);
    if (loader == null) {
      return SizedBox(child: listViewBuilder(snapshot));
    } else {
      return loader;
    }
  }

  Widget listViewBuilder(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.size == 0
        ? const Center(child: Text("Keine To-Do's vorhanden"))
        : ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: (site == "Dashboard")
                ? snapshot.data!.docs.length < 5
                    ? snapshot.data!.docs.length
                    : 5
                : snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Todo todo = Todo.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              todos.add(todo);
              return ToDoTile(
                todo: todo,
                index: index,
              );
            });
  }
}
