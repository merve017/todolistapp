import 'package:flutter/material.dart';
import 'package:todolist_app/screens/lists/components/liststreambuilder.dart';
import 'package:todolist_app/service/todo_service.dart';

class ActualTodoList extends StatefulWidget {
  const ActualTodoList({Key? key}) : super(key: key);
  @override
  _ActualTodoList createState() => _ActualTodoList();
}

class _ActualTodoList extends State<ActualTodoList> {
  String type = "ALL";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(physics: const ClampingScrollPhysics(), children: [
      ExpansionTile(
          title: const Text("Aktuelle To-Do's"),
          initiallyExpanded: true,
          children: [
            ListStreamBuilder(
                query:
                    TodoService().getTodoListOfCurrentUserofOpenTodosOfToday())
            //,site: 'ACTUALLIST')
          ]),
      ExpansionTile(
          title: const Text("Überfällige To-Do's"),
          initiallyExpanded: false,
          children: [
            ListStreamBuilder(
                query: TodoService()
                    .getTodoListOfCurrentUserofOverdueTodosOfToday())
            //,site: 'OVERDUELIST')
          ]),
      ExpansionTile(
          title: const Text("Geschlossene To-Do's"),
          initiallyExpanded: false,
          children: [
            ListStreamBuilder(
                query: TodoService()
                    .getTodoListOfCurrentUserofClosedTodosOfToday())
            //,site: 'CLOSED')
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
