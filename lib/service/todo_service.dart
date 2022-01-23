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

  Stream<QuerySnapshot> getTodoListOfCurrentUserofClosedTodos() {
    return getCollectionReference()
        .where("status", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofOpenTodosOfFuture() {
    return getCollectionReference()
        .where("status", isEqualTo: false)
        .where("dueDate", isGreaterThan: DateTime.now())
        .snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofOpenTodosOfTodayLimit5() {
    final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch);
    return getCollectionReference()
        .where("status", isEqualTo: false)
        .where("due_date", isLessThan: startAtTimestamp)
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofOpenTodosOfTodayAll() {
    final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch);
    return getCollectionReference()
        .where("status", isEqualTo: false)
        .where("due_date", isLessThan: startAtTimestamp)
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofOpenTodosOfToday() {
    final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .millisecondsSinceEpoch);
    final endAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime(2000, 1, 1).millisecondsSinceEpoch);

    return getCollectionReference()
        .where("status", isEqualTo: false)
        .where("due_date", isLessThan: startAtTimestamp)
        .where("due_date", isEqualTo: endAtTimestamp)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofOverdueTodosOfToday() {
    final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    final endAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime(2000, 1, 1).millisecondsSinceEpoch);

    return getCollectionReference()
        .where("status", isEqualTo: false)
        .where("due_date", isLessThan: startAtTimestamp)
        .where("due_date", isNotEqualTo: endAtTimestamp)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUserofClosedTodosOfToday() {
    return getCollectionReference()
        .where("status", isEqualTo: true)
        .where("doneDate", isEqualTo: DateTime.now())
        .snapshots();
  }

  /*
        getData() async {
          List<Stream<QuerySnapshot>> streams = [];
          final someCollection = Firestore.instance.collection("users");
          var firstQuery = someCollection
              .where('myQUestion', isEqualTo: 'nameQuestion')
              .snapshots();

          var secondQuery = someCollection
              .where('myQuestion', isEqualTo: 'ageQuestion')
              .snapshots();

          streams.add(firstQuery);
          streams.add(secondQuery);

          Stream<QuerySnapshot> results = StreamGroup.merge(streams);
          await for (var res in results) {
            res.documents.forEach((docResults) {
              print(docResults.data);
            });
          }
        }*/

  deleteByRID(String rid) async {
    getCollectionReference()
        .where("rid", isEqualTo: rid)
        .where("due_date", isGreaterThanOrEqualTo: DateTime.now())
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
