import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todolist_app/models/todo_model.dart';

class ColumnDefault extends StatelessWidget {
  ColumnDefault({Key? key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  int high = 0;
  int medium = 0;
  int low = 0;
  int notprioritized = 0;

  final TooltipBehavior? _tooltipBehavior =
      TooltipBehavior(enable: true, header: '', canShowMarker: false);

  @override
  Widget build(BuildContext context) {
    sumUp();
    return _buildDefaultColumnChart();
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'offene To-Dos nach Priorität'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Nicht priorisiert', y: notprioritized as double),
          ChartSampleData(x: 'Niedrig', y: low as double),
          ChartSampleData(x: 'Mittel', y: medium as double),
          ChartSampleData(x: 'Hoch', y: high as double),
        ],
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
        borderRadius: BorderRadius.circular(10),
      )
    ];
  }

  sumUp() {
    for (var item in snapshot.data!.docs) {
      Todo todo = Todo.fromJson(item.data() as Map<String, dynamic>);
      if (todo.status == false) {
        switch (todo.priority) {
          case 1:
            notprioritized++;
            break;
          case 2:
            low++;
            break;
          case 3:
            medium++;
            break;
          case 4:
            high++;
            break;
          default:
        }
      }
    }
  }
}

class ChartSampleData {
  ChartSampleData({required this.x, required this.y, this.color, this.text});
  final String x;
  final double y;
  final Color? color;
  final String? text;
}
