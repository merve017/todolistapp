import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

import 'components/bar_chart.dart';
import 'components/pie_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool loading = false;

//  var number = sumOfAllTodos();
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
                return const Center(child: Text("Keine To-Do's vorhanden"));
              } else {
                // if (snapshot.hasData && snapshot.data!.size > 0) {
                return SingleChildScrollView(
                    controller: ScrollController(),
                    child: Wrap(
                      children: [
                        // snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['status'].toString());
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Anzahl der Todos: ${snapshot.data!.size}')),
                        placeHolder,
                        SimplePieChart(snapshot: snapshot),
                        placeHolder,
                        ColumnDefault(snapshot: snapshot)
                      ],
                    ));
              }
            });
  }
}
