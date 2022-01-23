import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todolist_app/models/todo_model.dart';

class SimplePieChart extends StatelessWidget {
  // final List<charts.Series> seriesList;
  //final bool animate;

  SimplePieChart({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot<QuerySnapshot> snapshot;
  late int openTodo = 0;

  @override
  Widget build(BuildContext context) {
    return _buildDefaultPieChart();
  }

  SfCircularChart _buildDefaultPieChart() {
    sumUp();
    return SfCircularChart(
      title: ChartTitle(
          text:
              "To-Dos nach Status"), // isCardView ? '' : 'Sales by sales person'),
      // legend: Legend(isVisible: true), //!isCardView),
      series: _getDefaultPieSeries(),
    );
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'Offen', y: openTodo.toDouble(), text: 'Open $openTodo'),
            ChartSampleData(
                x: 'Abgeschlossen',
                y: (snapshot.data!.size - openTodo).toDouble(),
                text: 'Done \n ${snapshot.data!.size - openTodo}')
          ],
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }

  sumUp() {
    for (var item in snapshot.data!.docs) {
      Todo todo = Todo.fromJson(item.data() as Map<String, dynamic>);
      todo.status == false ? openTodo++ : "";
    }
    return openTodo;
  }
}

class ChartSampleData {
  ChartSampleData({required this.x, required this.y, this.color, this.text});
  final String x;
  final double y;
  final Color? color;
  final String? text;
}
