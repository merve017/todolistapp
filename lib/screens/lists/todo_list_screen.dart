import 'package:flutter/material.dart';
import 'package:todolist_app/screens/lists/components/liststreambuilder.dart';
import 'package:todolist_app/service/todo_service.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        controller: ScrollController(),
        physics: const ClampingScrollPhysics(),
        children: [
          ExpansionTile(
              title: const Text("Offene To-Do's"),
              initiallyExpanded: true,
              children: [
                ListStreamBuilder(
                    query: TodoService().getTodoListOfCurrentUserofOpenTodos())
              ]),
          ExpansionTile(
              title: const Text("Erledigte To-Do's"),
              initiallyExpanded: true,
              children: [
                ListStreamBuilder(
                    query:
                        TodoService().getTodoListOfCurrentUserofClosedTodos())
              ]),
        ]);
  }

  /*getData(bool status) async {
    //import 'package:async/async.dart' show StreamGroup;
    List<Stream<QuerySnapshot>> streams = [];
    streams.add(TodoService().getTodoListOfCurrentUserofOpenTodos());
    streams.add(TodoService().getTodoListOfCurrentUserofClosedTodos());
    Todo todo;
    Stream<QuerySnapshot> results = StreamGroup.merge(streams);
    await for (var res in results) {
      todo = Todo.fromJson(res.docs[0].data() as Map<String, dynamic>);
      if (todo.status = false) {
        loadingScreens(snapshot, "Offene To-Do's");
      }
      for (var docResults in res.docs) {
        //snapshots
        /* if (docResults.data() != null) {
          for (Object i in docResults.data.size) {}
        }*/
        print("next todo:");
        todo = Todo.fromJson(docResults.data() as Map<String, dynamic>);
        // print("status: {$todo.status}");
        print(docResults.data());
        print(todo.status);
        //  snapshot.data!.docs[index].data()
      }
    }
  }*/
}
