import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist_app/models/routine_model.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/service/routine_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';

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
            //controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
                openRoutineTasks(),
                closedRoutineTasks(),
              ]);
  }

  Widget toDoTile(BuildContext context, RoutineTask routineTask, int index) {
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
                    routineTask: routineTask,
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
                {RoutineService().deleteByID(routineTask.rid as String)},
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
            leading: Icon(Icons.fiber_manual_record, color: color(routineTask)),
            title: Text(
              routineTask.title,
              style: const TextStyle(color: Colors.black),
              maxLines: 2,
            ),
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Description: ${routineTask.description}',
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
                          return toDoTile(context, routineTask, index);
                        }))
          ]);
    }
  }
}
