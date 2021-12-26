import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('To-Do List'),
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
        ),
        body: loading
            ? const Loading()
            : StreamBuilder<QuerySnapshot>(
                stream: TodoService().getTodoListOfCurrentUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  const Loading();
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                    // Fluttertoast.showToast(msg: 'Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Text(
                        "Loading",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.data!.size == 0) {
                    return const Center(child: Text("All ToDos are caught up"));
                  } else {
                    // if (snapshot.hasData && snapshot.data!.size > 0) {
                    return Wrap(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Anzahl der Todos: ${snapshot.data!.size}')),
                        placeHolder,
                        const Counts(),
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: SimplePieChart.withSampleData())
                      ],
                    );
                  }
                }));
  }
}

class Counts extends StatelessWidget {
  const Counts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: TodoService().getTodoListOfCurrentUserofOpenTodos(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Wrap(//alignment: Alignment.centerLeft,
              children: [
            const Text("Anzahl"),
            snapshot.data == null
                ? const Text("0")
                : Text("${snapshot.data!.size}"),
          ]);
        });
  }
}

class SimplePieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  const SimplePieChart(
      {Key? key, required this.seriesList, required this.animate})
      : super(key: key);

  /// Creates a [PieChart] with sample data and no transition.
  factory SimplePieChart.withSampleData() {
    return SimplePieChart(
      seriesList: _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 100),
      LinearSales(1, 75),
      LinearSales(2, 25),
      LinearSales(3, 5),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
