import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/service/database_service.dart';

class TodoService extends DatabaseService {
  @override
  CollectionReference getCollectionReference() {
    return DatabaseService.db
        .collection("users")
        .doc(AuthService.user!.uid)
        .collection("todo");
  }

  @override
  String getID() {
    return getCollectionReference().doc().id;
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUser() {
    return getCollectionReference().snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofOpenTodos() {
    return getCollectionReference()
        .where("status", isEqualTo: false)
        .snapshots();
  }
}
