import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/loading.dart';

class AgendaViewCalendar extends StatefulWidget {
  const AgendaViewCalendar({Key? key}) : super(key: key);

  @override
  _AgendaViewCalendarState createState() => _AgendaViewCalendarState();
}

class _AgendaViewCalendarState extends State<AgendaViewCalendar> {
  _AgendaViewCalendarState();
  bool isWebFullView = kIsWeb == true ? true : false;
  late _MeetingDataSource _events;
  final CalendarController _calendarController = CalendarController();
  late Orientation _deviceOrientation;
  late List<Todo> _todos;

  @override
  void initState() {
    _calendarController.selectedDate = DateTime.now();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: TodoService().getTodoListOfCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          const Loading();
          if (snapshot.hasError) {
            return const Text(
                "Etwas ging schief - bitte aktualisiere die Seite");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                "Laden...",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return isWebFullView == false &&
                    _deviceOrientation == Orientation.landscape
                ? Scrollbar(
                    child: ListView(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        height: 600,
                        child: _getAgendaViewCalendar(
                            _getAppointments(snapshot),
                            _onViewChanged,
                            _calendarController),
                      )
                    ],
                  ))
                : Container(
                    color: Colors.white,
                    child: _getAgendaViewCalendar(_getAppointments(snapshot),
                        _onViewChanged, _calendarController),
                  );
          }
        });
  }

  _MeetingDataSource _getAppointments(AsyncSnapshot<QuerySnapshot> snapshot) {
    _todos = <Todo>[];

    final List<Color> colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));

    final List<_Meeting> meetings = <_Meeting>[];
    final Random random = Random();
    for (var item in snapshot.data!.docs) {
      Todo todo = Todo.fromJson(item.data() as Map<String, dynamic>);
      _todos.add(Todo.fromJson(item.data() as Map<String, dynamic>));
      meetings.add(_Meeting(
          todo.title,
          getDate(todo.doneDate, todo.dueDate),
          getDate(todo.doneDate, todo.dueDate),
          colorCollection[random.nextInt(9)],
          true,
          '',
          '',
          todo.routine == true ? freq(todo) : ''));
    }
    _events = _MeetingDataSource(meetings);
    return _events;
  }

  DateTime getDate(DateTime? doneDate, DateTime? dueDate) {
    if (doneDate != null) {
      return doneDate;
    }
    if (dueDate != null) {
      if (dueDate.isAfter(DateTime.now())) {
        return dueDate;
      }
    }
    return DateTime.now();
  }

  String freq(Todo todo) {
    String output = '';
    switch (todo.repetition) {
      case 3:
        output += 'FREQ=MONTHLY;';
        break;
      case 4:
        output += 'FREQ=YEARLY;';
        break;
      default:
        output += 'FREQ=WEEKLY;';
    }
    output += "BYDAY=";
    String weekdays = '';
    for (int i = 0; i < todo.weekdays.length; i++) {
      if (todo.weekdays[i]) {
        weekdays != '' ? weekdays += ',' : '';
        switch (i) {
          case 1:
            weekdays += 'MO';
            break;
          case 2:
            weekdays += 'TU';
            break;
          case 3:
            weekdays += 'WE';
            break;
          case 4:
            weekdays += 'TH';
            break;
          case 5:
            weekdays += 'FR';
            break;
          case 6:
            weekdays += 'SA';
            break;
          case 0:
            weekdays += 'SU';
            break;
          default:
            weekdays += 'MO';
            break;
        }
      }
    }
    output += weekdays;

    output += ";INTERVAL=1";

    if (todo.dueDate != null) {
      output +=
          ';UNTIL=${todo.dueDate!.year}${todo.dueDate!.month.toString().padLeft(2, '0')}${todo.dueDate!.day.toString().padLeft(2, '0')}T235959Z';
    }

    return output;
  }

  /// Updated the selected date of calendar, when the months swiped, selects the
  /// current date when the calendar displays the current month, and selects the
  /// first date of the month for rest of the months.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      final DateTime currentViewDate = visibleDatesChangedDetails
          .visibleDates[visibleDatesChangedDetails.visibleDates.length ~/ 2];
      if (isWebFullView) {
        if (DateTime.now()
                .isAfter(visibleDatesChangedDetails.visibleDates[0]) &&
            DateTime.now().isBefore(visibleDatesChangedDetails.visibleDates[
                visibleDatesChangedDetails.visibleDates.length - 1])) {
          _calendarController.selectedDate = DateTime.now();
        } else {
          _calendarController.selectedDate =
              visibleDatesChangedDetails.visibleDates[0];
        }
      } else {
        if (currentViewDate.month == DateTime.now().month &&
            currentViewDate.year == DateTime.now().year) {
          _calendarController.selectedDate = DateTime.now();
        } else {
          _calendarController.selectedDate =
              DateTime(currentViewDate.year, currentViewDate.month, 01);
        }
      }
    });
  }

  SfCalendar _getAgendaViewCalendar(
      [CalendarDataSource? calendarDataSource,
      ViewChangedCallback? onViewChanged,
      CalendarController? controller]) {

    return SfCalendar(
      view: CalendarView.month,
      controller: controller,
      showDatePickerButton: true,
      showNavigationArrow: isWebFullView,
      onViewChanged: onViewChanged,
      dataSource: calendarDataSource,
      monthViewSettings: MonthViewSettings(
          showAgenda: true, numberOfWeeksInView: isWebFullView ? 6 : 2),
      timeSlotViewSettings: const TimeSlotViewSettings(
          minimumAppointmentDuration: Duration(minutes: 60)),
    );
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<_Meeting> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  String? getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String? getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  String? getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
  }
}

class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.startTimeZone, this.endTimeZone, this.recurrenceRule);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String? startTimeZone;
  String? endTimeZone;
  String? recurrenceRule;
}
