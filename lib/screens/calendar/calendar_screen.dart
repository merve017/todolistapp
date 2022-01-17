library event_calendar;

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/screens/add_edit_todo.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/loading.dart';

part 'widget.dart';

//ignore: must_be_immutable
class EventCalendar extends StatefulWidget {
  CalendarView? calendarView;
  EventCalendar({Key? key, this.calendarView}) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

late MeetingDataSource _events;

class EventCalendarState extends State<EventCalendar> {
  EventCalendarState();

  late CalendarView _calendarView;
  late List<String> eventNameCollection;
  late List<Todo> todos;
  final CalendarController _calendarController = CalendarController();
  late Orientation _deviceOrientation;

  @override
  void initState() {
    _calendarView = widget.calendarView ?? CalendarView.month;
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
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: kIsWeb && _deviceOrientation == Orientation.landscape
                        ? Scrollbar(
                            child: ListView(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                //color: model.cardThemeColor,
                                height: 600,
                                child: getEventCalendar(
                                    _calendarView,
                                    _onViewChanged,
                                    _calendarController,
                                    getAppointments(snapshot),
                                    onCalendarTapped),
                              )
                            ],
                          ))
                        : Container(
                            color: Colors.white,
                            //color: model.cardThemeColor,
                            child: getEventCalendar(
                                _calendarView,
                                _onViewChanged,
                                _calendarController,
                                getAppointments(snapshot),
                                onCalendarTapped),
                          )));
          }
        });
  }

  SfCalendar getEventCalendar(
      CalendarView _calendarView,
      ViewChangedCallback? onViewChanged,
      CalendarController? controller,
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
      view: widget.calendarView ?? CalendarView.month,
      onViewChanged: onViewChanged,
      firstDayOfWeek: 1,
      controller: controller,
      allowViewNavigation: false,
      dataSource: _calendarDataSource,
      onTap: calendarTapCallback,
      scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: false,
          dayHeaderSettings: const DayHeaderSettings(
              dayFormat: 'EEEE',
              width: 70,
              dayTextStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
              dateTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.red,
              )),
          weekHeaderSettings: WeekHeaderSettings(
              weekTextStyle: TextStyle(
                color: Colors.blue[100],
              ),
              startDateFormat: 'MMMM dd, yyyy',
              endDateFormat: 'MMMM dd, yyyy'),
          monthHeaderSettings: MonthHeaderSettings(
              monthFormat: 'MMMM, yyyy',
              height: 100,
              textAlign: TextAlign.left,
              backgroundColor: Colors.blue[100] ?? Colors.blue,
              monthTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400))),
      showNavigationArrow: true,
      showDatePickerButton: true,
      appointmentBuilder: appointmentBuilder,
      // initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
      //     DateTime.now().day, 0, 0, 0),
      monthViewSettings: const MonthViewSettings(
        showAgenda: true,
        //appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
          minimumAppointmentDuration: Duration(minutes: 60)),
    );
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      _calendarController.selectedDate = calendarTapDetails.date;
    } else {
      setState(() {
        Navigator.push<Widget>(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddEditTodo(),
            ));
      });
    }
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      final DateTime currentViewDate = visibleDatesChangedDetails
          .visibleDates[visibleDatesChangedDetails.visibleDates.length ~/ 2];
      if (kIsWeb) {
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

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Todo meeting = calendarAppointmentDetails.appointments.first;
    var items = [
      {'name': 'Gehe zum aktuellen Todo', 'value': 0},
      {'name': 'Gehe zur Routineaktivität', 'value': 1}
    ];
    return meeting.rid == null
        ? ListTile(
            title: Text(meeting.title),
            tileColor: colorCollection(),
            leading: const Icon(Icons.done),
            onTap: () {
              setState(() {
                Navigator.push<Widget>(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddEditTodo(todo: meeting)), // AppointmentEditor()),
                );
              });
            },
          )
        : PopupMenuButton(
            child: (ListTile(
                title: Text(meeting.title),
                leading: const Icon(Icons.done),
                trailing: const Icon(Icons.repeat_rounded))),
            onSelected: (x) {
              if (x == 0) {
                setState(() {
                  Navigator.push<Widget>(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddEditTodo(
                            todo: meeting)), // AppointmentEditor()),
                  );
                });
              } else if (x == 1) {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddEditTodo(rid: meeting.rid as String)));
                });
              }
            },
            itemBuilder: (context) => items
                .map<PopupMenuItem>((element) => PopupMenuItem(
                      child: Text(element['name'] as String),
                      value: element['value'],
                    ))
                .toList());
  }
}
