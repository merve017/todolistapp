import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/statistics/components/bar_chart.dart';
import 'package:todolist_app/screens/statistics/components/pie_chart.dart';
import 'package:todolist_app/service/todo_service.dart';

import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

class StatisticsInfos extends StatelessWidget {
  const StatisticsInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: TodoService().getTodoListOfCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          const Loading();
          if (snapshot.hasError) {
            return const Text("Etwas ging schief :(");
            // Fluttertoast.showToast(msg: 'Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                "Loading",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.data!.size == 0) {
            return const Center(child: Text("Keine Statistiken vorhanden"));
          } else {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Statistiken",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  SimplePieChart(
                    snapshot: snapshot,
                  ),
                  ColumnDefault(
                    snapshot: snapshot,
                  ),
                ],
              ),
            );
          }
        });
  }
}
