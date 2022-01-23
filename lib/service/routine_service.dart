// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/service/database_service.dart';

class RoutineService extends DatabaseService {
  @override
  CollectionReference getCollectionReference() {
    return DatabaseService.db
        .collection("users")
        .doc(AuthService.user!.uid)
        .collection("routine");
  }

  @override
  String getID() {
    return getCollectionReference().doc().id;
  }

  @override
  add(Map<String, dynamic> data) async {
    //String id = getID();
    //data['rid'] = id;
    data['created_at'] = DateTime.now();
    await getCollectionReference().doc(data['rid']).set(data);
  }

  @override
  updateByID(Map<String, dynamic> data, String documentUUID) async {
    data['updated_at'] = DateTime.now();
    data['rid'] = documentUUID;
    await getDocumentReference(documentUUID).update(data);
  }

  Stream<QuerySnapshot> getRoutineTasksListOfCurrentUser() {
    return getCollectionReference().snapshots();
  }

  Stream<QuerySnapshot> getRoutineTasks(String rid) {
    return getCollectionReference().where("rid", isEqualTo: rid).snapshots();
  }

  Stream<QuerySnapshot> getRoutineTasksOfCurrentUserofOpen() {
    return getCollectionReference()
        .where("due_date", isGreaterThanOrEqualTo: DateTime.now())
        .snapshots();
  }

  Stream<QuerySnapshot> getRoutineTasksOfCurrentUserofClosed() {
    return getCollectionReference()
        .where("due_date", isLessThan: DateTime.now())
        .snapshots();
  }
}
