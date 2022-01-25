part of event_calendar;

MeetingDataSource getAppointments(dynamic snapshot) {
  final List<Todo> todos = <Todo>[];
  for (var item in snapshot.data!.docs) {
    Todo todo = Todo.fromJson(item.data());
    todos.add(todo);
  }
  _events = MeetingDataSource(todos);
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
  /*switch (todo.repetition) {
    case 3:
      output += 'FREQ=MONTHLY;';
      break;
    case 4:
      output += 'FREQ=YEARLY;';
      break;
    default:
      output += 'FREQ=DAILY;';
  }*/
  output += 'FREQ=DAILY;';
  output += "BYDAY=";
  /*String weekdays = '';
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
  output += weekdays;*/

  output += ";INTERVAL=1";

  if (todo.dueDate != null) {
    output +=
        ';UNTIL=${todo.dueDate!.year}${todo.dueDate!.month.toString().padLeft(2, '0')}${todo.dueDate!.day.toString().padLeft(2, '0')}T235959Z';
  }

  return output;
}

List<Todo> getMeetingDetails(dynamic snapshot) {
  final List<Todo> meetings = <Todo>[];

  for (var item in snapshot.data!.docs) {
    Todo todo = Todo.fromJson(item.data());
    meetings.add(todo);
  }
  return meetings;
}

class MeetingDataSource extends CalendarDataSource<Todo> {
  MeetingDataSource(this.source);

  List<Todo> source;

  @override
  List<Todo> get appointments => source;

  String id(int index) {
    return source[index].uid ?? '';
  }

  @override
  DateTime getStartTime(int index) {
    return getDate(source[index].doneDate, source[index].dueDate);
  }

  @override
  DateTime getEndTime(int index) {
    return getDate(source[index].doneDate, source[index].dueDate);
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String getSubject(int index) {
    return source[index].title;
  }

  @override
  Color getColor(int index) {
    return colorCollection();
  }

  @override
  String? getRecurrenceRule(int index) {
    return source[index].rid != null ? freq(source[index]) : '';
  }

  @override
  Todo convertAppointmentToObject(Todo customData, Appointment appointment) {
    return Todo(
        //  dueDate: appointment.startTime,
        dueDate: appointment.endTime,
        title: appointment.subject,
        description: customData.description ?? 'Das ist eine Description',
        priority: customData.priority,
        status: customData.status,
        uid: customData.uid,
        doneDate: customData.doneDate,
        rid: customData.rid);
    // background: appointment.color,
    // isAllDay: appointment.isAllDay);
  }
}

Color colorCollection() {
  final Random random = Random();
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

  return colorCollection[random.nextInt(9)];
}
