import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttendanceData {
  final DateTime date;
  final int present;

  AttendanceData({required this.date, required this.present});
}

class AttendancePage extends StatefulWidget {
  static const routeName = '/attendance';
  AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<AttendanceData> data = [
    AttendanceData(
        date: DateTime.now().subtract(const Duration(days: 4)), present: 10),
    AttendanceData(
        date: DateTime.now().subtract(const Duration(days: 3)), present: 8),
    AttendanceData(
        date: DateTime.now().subtract(const Duration(days: 2)), present: 12),
    AttendanceData(
        date: DateTime.now().subtract(const Duration(days: 1)), present: 15),
    AttendanceData(date: DateTime.now(), present: 13),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 300,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryYAxis: NumericAxis(
              labelPosition: ChartDataLabelPosition.inside,
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 0),
              title: AxisTitle(text: 'Date'),
            ),
            primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(width: 0),
              dateFormat: DateFormat('dd/MM'),
              title: AxisTitle(text: 'Date (DD/MM)'),
            ),
            // Chart title
            title: ChartTitle(text: 'Attendance of workers of this week'),
            // Enable legend
            legend: Legend(isVisible: false),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: [
              ColumnSeries<AttendanceData, DateTime>(
                color: Colors.lightGreen,
                dataSource: data,
                xValueMapper: (AttendanceData sales, _) => sales.date,
                yValueMapper: (AttendanceData sales, _) => sales.present,
                isTrackVisible: true,
                trackColor: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                name: 'Attendance',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
