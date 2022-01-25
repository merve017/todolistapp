import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/models/routine_model.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/service/routine_service.dart';
import 'package:todolist_app/shared/loading.dart';

import 'components/todo_tile.dart';

class RoutineList extends StatefulWidget {
  const RoutineList({Key? key}) : super(key: key);
  @override
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  bool loading = false;
  int selectedExpansionTile = -1;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : ListView(
            controller: ScrollController(),
            //controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
                openRoutineTasks(),
                closedRoutineTasks(),
              ]);
  }

  Widget openRoutineTasks() {
    return StreamBuilder<QuerySnapshot>(
        stream: RoutineService().getRoutineTasksOfCurrentUserofOpen(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return loadingScreens(snapshot, "Offene Routinetätigkeiten");
        });
  }

  Widget closedRoutineTasks() {
    return StreamBuilder<QuerySnapshot>(
        stream: RoutineService().getRoutineTasksOfCurrentUserofClosed(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return loadingScreens(snapshot, "Abgelaufene Routinetätigkeiten");
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
    } else {
      // if (snapshot.hasData && snapshot.data!.size > 0) {
      return ExpansionTile(
          title: Text(title),
          initiallyExpanded: title.contains("Offen") ? true : false,
          children: [
            snapshot.data!.size == 0
                ? Center(child: Text("Keine $title vorhanden"))
                : SizedBox(
                    //height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          RoutineTask routineTask = RoutineTask.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          return ToDoTile(
                              routineTask: routineTask, index: index);
                        }))
          ]);
    }
  }
}
